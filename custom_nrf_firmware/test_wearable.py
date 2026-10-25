import asyncio
import shutil
import struct
import time
from bleak import BleakScanner, BleakClient

IMU_SERVICE_UUID = "00001523-1212-efde-1523-785feabcd123"
IMU_CHARACTERISTIC_UUID = "00001526-1212-efde-1523-785feabcd123"
DEVICE_NAME = "IMU_wearable"  # CONFIG_BT_DEVICE_NAME in prj.conf

# struct imu_data: acc[3], gyr[3], each {int32 integer, int32 fraction (micro-units)}
IMU_FORMAT = "<12i"
IMU_SIZE = struct.calcsize(IMU_FORMAT)  # 48

# Trailer after imu_data, keyed by total packet size (C struct padded to 4 bytes)
TRAILER_FORMATS = {
    52: ("<HBx", ("foot_voltage", "pos")),                      # uint16, uint8
    56: ("<HHB3x", ("foot_voltage", "foot_voltage2", "pos")),   # uint16, uint16, uint8
}


def decode_wearable_packet(data):
    """Decode a wearable_packet notification. Returns None if the size is unknown."""
    if len(data) not in TRAILER_FORMATS:
        print(f"Unsupported packet size: {len(data)} bytes")
        return None

    raw = struct.unpack_from(IMU_FORMAT, data)
    # Zephyr sensor_value = val1 + val2 / 1e6 (val2 carries the sign too)
    vals = [raw[i] + raw[i + 1] / 1_000_000 for i in range(0, 12, 2)]

    fmt, names = TRAILER_FORMATS[len(data)]
    trailer = dict(zip(names, struct.unpack_from(fmt, data, IMU_SIZE)))

    return {
        "acc": dict(zip("xyz", vals[0:3])),  # m/s^2
        "gyr": dict(zip("xyz", vals[3:6])),  # rad/s
        **trailer,
    }


DISPLAY_PERIOD = 0.25  # seconds between terminal refreshes

# Updated by the notification handler, read by the display loop
latest = {"packet": None, "raw": None}
count = 0           # notifications received since the last refresh
last_arrival = None  # perf_counter time of the most recent notification


# Running stats of the time between notifications (Welford's algorithm), in seconds
period = {"n": 0, "mean": 0.0, "m2": 0.0, "min": float("inf"), "max": 0.0}


def record_period(dt):
    period["n"] += 1
    delta = dt - period["mean"]
    period["mean"] += delta / period["n"]
    period["m2"] += delta * (dt - period["mean"])
    period["min"] = min(period["min"], dt)
    period["max"] = max(period["max"], dt)


def print_period_stats():
    n = period["n"]
    if n < 2:
        print("Not enough notifications to compute period statistics.")
        return
    mean = period["mean"]
    var = period["m2"] / (n - 1)  # sample variance
    print(
        f"Receive period over {n + 1} notifications ({n} intervals):\n"
        f"  mean     = {mean * 1e3:8.3f} ms  ({1 / mean:.1f} Hz)\n"
        f"  variance = {var * 1e6:8.3f} ms^2\n"
        f"  std dev  = {var ** 0.5 * 1e3:8.3f} ms\n"
        f"  min/max  = {period['min'] * 1e3:.3f} / {period['max'] * 1e3:.3f} ms"
    )


def notification_handler(sender, data):
    """Record the newest notification; printing is done by display_loop."""
    global count, last_arrival
    now = time.perf_counter()
    if last_arrival is not None:
        record_period(now - last_arrival)
    last_arrival = now
    count += 1
    latest["packet"] = decode_wearable_packet(data)
    latest["raw"] = data


def format_line(packet, rate):
    acc, gyr = packet["acc"], packet["gyr"]
    # foot_voltage fields are millivolts from the firmware's ADC (12-bit, 0-3.6 V range)
    foot = ""
    if "foot_voltage" in packet:
        foot = f" | foot1={packet['foot_voltage'] / 1000:5.3f} V"
        if "foot_voltage2" in packet:
            foot += f" foot2={packet['foot_voltage2'] / 1000:5.3f} V"
    pos = f" pos={packet['pos']}" if "pos" in packet else ""
    return (
        f"{rate:6.1f} Hz | "
        f"acc x={acc['x']:8.4f} y={acc['y']:8.4f} z={acc['z']:8.4f} | "
        f"gyr x={gyr['x']:8.4f} y={gyr['y']:8.4f} z={gyr['z']:8.4f}{foot}{pos}"
    )


async def display_loop():
    """Redraw one terminal line every DISPLAY_PERIOD with the latest sample and rate."""
    global count
    prev_arrival = None  # arrival time of the last notification in the previous window
    while True:
        await asyncio.sleep(DISPLAY_PERIOD)
        n, end = count, last_arrival
        count = 0
        if n == 0:
            line = "waiting for notifications..." if prev_arrival is None else f"{0.0:6.1f} Hz | no data"
        else:
            # rate from notification arrival times: n intervals between the previous
            # window's last packet and this window's last packet
            if prev_arrival is not None and end > prev_arrival:
                rate = n / (end - prev_arrival)
            else:
                rate = 0.0
            prev_arrival = end
            packet = latest["packet"]
            if packet:
                line = format_line(packet, rate)
            else:
                line = f"{rate:6.1f} Hz | raw ({len(latest['raw'])} bytes): {latest['raw'].hex()}"
        width = shutil.get_terminal_size().columns - 1
        # \r returns to column 0; padding overwrites leftovers from a longer previous line
        print("\r" + line[:width].ljust(width), end="", flush=True)


async def main():
    print("Scanning for devices...")
    devices = await BleakScanner.discover(return_adv=True)
    target_address = None

    for device, adv in devices.values():
        uuids = [uuid.lower() for uuid in adv.service_uuids]
        if adv.local_name == DEVICE_NAME or IMU_SERVICE_UUID in uuids:
            target_address = device.address
            print(f"Found device: {device.address} - {adv.local_name}")
            break

    if not target_address:
        target_address = input("Enter the target device BLE address: ")

    # Windows caches the GATT table per device address; the firmware's attribute handles
    # change whenever the service layout does, so don't trust the cache
    async with BleakClient(target_address, winrt=dict(use_cached_services=False)) as client:
        print(f"Connected to {target_address}")

        await client.start_notify(IMU_CHARACTERISTIC_UUID, notification_handler)
        print(f"Subscribed to notifications on {IMU_CHARACTERISTIC_UUID}")

        try:
            await display_loop()
        finally:
            await client.stop_notify(IMU_CHARACTERISTIC_UUID)
            print("\nStopped notifications and disconnected.")


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        pass
    finally:
        print_period_stats()
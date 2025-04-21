import asyncio
import struct
from bleak import BleakScanner, BleakClient

IMU_SERVICE_UUID = "00001523-1212-efde-1523-785feabcd123"
IMU_CHARACTERISTIC_UUID = "00001526-1212-efde-1523-785feabcd123"

def decode_wearable_packet(data):
    """Decode the wearable_packet from raw bytes."""
    expected_size = 51
    print(f"Packet size: {len(data)} bytes (expected {expected_size})")
    
    if len(data) < expected_size:
        print(f"Error: Packet too short, got {len(data)} bytes")
        return None
    
    # Base format for 51 bytes: 12 int32_t (acc + gyr), 1 uint16_t, 1 uint8_t
    base_format = '<iiiiiiiiiiiiHB'
    base_size = struct.calcsize(base_format)  # Should be 51
    
    # Handle extra bytes (e.g., 52 bytes)
    if len(data) == 52:
        # Assume extra byte is at the end (e.g., uint8_t extra_field)
        format_str = base_format + 'B'  # Add one more uint8_t
        try:
            unpacked = struct.unpack(format_str, data)
            acc_x = unpacked[0] + unpacked[1] / 1_000_000
            acc_y = unpacked[2] + unpacked[3] / 1_000_000
            acc_z = unpacked[4] + unpacked[5] / 1_000_000
            gyr_x = unpacked[6] + unpacked[7] / 1_000_000
            gyr_y = unpacked[8] + unpacked[9] / 1_000_000
            gyr_z = unpacked[10] + unpacked[11] / 1_000_000
            foot_voltage = unpacked[12]
            pos = unpacked[13]
            extra_byte = unpacked[14]
            
            return {
                "acc": {"x": acc_x, "y": acc_y, "z": acc_z},
                "gyr": {"x": gyr_x, "y": gyr_y, "z": gyr_z},
                "foot_voltage": foot_voltage,
                "pos": pos,
                "extra_byte": extra_byte
            }
        except struct.error as e:
            print(f"Decoding failed: {e}")
            return None
    elif len(data) == expected_size:
        # Original 51-byte decoding
        unpacked = struct.unpack(base_format, data)
        acc_x = unpacked[0] + unpacked[1] / 1_000_000
        acc_y = unpacked[2] + unpacked[3] / 1_000_000
        acc_z = unpacked[4] + unpacked[5] / 1_000_000
        gyr_x = unpacked[6] + unpacked[7] / 1_000_000
        gyr_y = unpacked[8] + unpacked[9] / 1_000_000
        gyr_z = unpacked[10] + unpacked[11] / 1_000_000
        foot_voltage = unpacked[12]
        pos = unpacked[13]
        
        return {
            "acc": {"x": acc_x, "y": acc_y, "z": acc_z},
            "gyr": {"x": gyr_x, "y": gyr_y, "z": gyr_z},
            "foot_voltage": foot_voltage,
            "pos": pos
        }
    else:
        print(f"Unsupported packet size: {len(data)} bytes")
        return None

async def notification_handler(sender, data):
    """Handle incoming notifications and display decoded IMU values."""
    print(f"Raw packet ({len(data)} bytes): {data.hex()}")
    
    packet = decode_wearable_packet(data)
    if packet:
        print("Decoded IMU values:")
        print(f"  Accelerometer: X={packet['acc']['x']:.6f}, Y={packet['acc']['y']:.6f}, Z={packet['acc']['z']:.6f}")
        print(f"  Gyroscope: X={packet['gyr']['x']:.6f}, Y={packet['gyr']['y']:.6f}, Z={packet['gyr']['z']:.6f}")
        print(f"  Foot Voltage: {packet['foot_voltage']} mV")
        print(f"  Position: {packet['pos']}")
        if "extra_byte" in packet:
            print(f"  Extra Byte: {packet['extra_byte']} (0x{packet['extra_byte']:02x})")
    else:
        print("Failed to decode packet.")

async def main():
    print("Scanning for devices...")
    devices = await BleakScanner.discover()
    target_device = None
    
    for device in devices:
        if device.name == 'IMU_wearable':  # Adjust this condition as needed
            target_device = device
            print(f"Found device: {device.address} - {device.name}")
            break
    
    if not target_device:
        target_address = input("Enter the target device BLE address: ")
        target_device = type('Device', (), {'address': target_address})()

    async with BleakClient(target_device.address) as client:
        if not client.is_connected:
            print("Failed to connect to the device.")
            return
        
        print(f"Connected to {target_device.address}")
        
        await client.start_notify(IMU_CHARACTERISTIC_UUID, notification_handler)
        print(f"Subscribed to notifications on {IMU_CHARACTERISTIC_UUID}")
        
        try:
            while True:
                await asyncio.sleep(1)
        except KeyboardInterrupt:
            await client.stop_notify(IMU_CHARACTERISTIC_UUID)
            print("Stopped notifications and disconnected.")

if __name__ == "__main__":
    asyncio.run(main())
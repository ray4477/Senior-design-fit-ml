import asyncio
from bleak import BleakScanner, BleakClient

# Define the UUIDs from your firmware
IMU_SERVICE_UUID = "00001523-1212-efde-1523-785feabcd123"
IMU_CHARACTERISTIC_UUID = "00001526-1212-efde-1523-785feabcd123"

async def notification_handler(sender, data):
    """Callback function to handle incoming notifications."""
    print(f"Notification from {sender}: {data.hex()}")  # Display data as hex
    # Optionally decode or process the data further based on your device's format
    # e.g., print(f"Decoded data: {list(data)}") for raw bytes

async def main():
    # Step 1: Scan for devices advertising the IMU service
    print("Scanning for devices...")
    devices = await BleakScanner.discover()
    target_device = None
    
    for device in devices:
        # Check if the IMU service UUID is advertised (may not always be visible in scan)
        if device.name or IMU_SERVICE_UUID.lower() in [uuid.lower() for uuid in device.metadata.get("uuids", [])]:
            target_device = device
            print(f"Found target device: {device.address} - {device.name}")
            break
    
    if not target_device:
        print("Target device not found. Trying to connect manually...")
        # If service UUID isn't advertised, you may need the device's MAC address beforehand
        # Replace with actual address if known, e.g., "XX:XX:XX:XX:XX:XX"
        target_address = input("Enter the target device BLE address: ")
        target_device = type('Device', (), {'address': target_address})()

    # Step 2: Connect to the device
    async with BleakClient(target_device.address) as client:
        if not client.is_connected:
            print("Failed to connect to the device.")
            return
        
        print(f"Connected to {target_device.address}")
        
        # Step 3: Enable notifications for the IMU characteristic
        await client.start_notify(IMU_CHARACTERISTIC_UUID, notification_handler)
        print(f"Subscribed to notifications on {IMU_CHARACTERISTIC_UUID}")
        
        # Step 4: Keep the script running to receive notifications
        try:
            while True:
                await asyncio.sleep(1)  # Keep the event loop alive
        except KeyboardInterrupt:
            await client.stop_notify(IMU_CHARACTERISTIC_UUID)
            print("Stopped notifications and disconnected.")

# Run the async function
if __name__ == "__main__":
    asyncio.run(main())
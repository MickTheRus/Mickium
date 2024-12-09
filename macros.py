import os
import subprocess
from evdev import InputDevice, list_devices, ecodes, categorize

# The name of the input device you want to capture
DEVICE_NAME = "Logitech LogiG TKL MKeyboard"

# Search for the device by name
def find_device_by_name(device_name):
    devices = [InputDevice(path) for path in list_devices()]
    for device in devices:
        if device.name == device_name:
            return device
    raise Exception(f"Device '{device_name}' not found.")

# Try to find the device by name
try:
    dev = find_device_by_name(DEVICE_NAME)
    print(f"Found device: {dev.name} at {dev.path}")

    # Grab the device so no other program can use it
    dev.grab()

    # Loop to read events from the device
    for event in dev.read_loop():
        if event.type == ecodes.EV_KEY:  # Check if the event is a key event
            key = categorize(event)
            if key.keystate == key.key_down:  # Check if the key is pressed down
                if key.keycode == 'KEY_ESC':  # Check if the key pressed is 'ESC'
                    subprocess.run(['echo', 'Hello World'])
                if key.keycode == 'KEY_J': 
                    subprocess.run(['ffplay', '/home/mick/Mickium/kys.mp3'])

except Exception as e:
    print(e)

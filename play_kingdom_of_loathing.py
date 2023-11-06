import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
from evdev import InputDevice, list_devices, categorize, ecodes
import threading
import os

# Define the path for the user data directory
user_data_dir = "/home/jarrod/mint_scripts/kol_settings"  # Replace with your desired path

# Check if the directory exists, if not, create it
if not os.path.exists(user_data_dir):
    os.makedirs(user_data_dir)
    print(f"Created directory {user_data_dir}")

# Check directory permissions
if not os.access(user_data_dir, os.W_OK):
    print(f"The directory {user_data_dir} is not writable. Check your permissions.")
    exit(1)

# Add options to the Chrome driver
chrome_options = Options()
chrome_options.add_argument(f"user-data-dir={user_data_dir}")  # Set user data directory

BTN_NORTH = 307  # The event code for btn_north

# Initialize the browser driver
#browser = webdriver.Chrome()
browser = webdriver.Chrome(options=chrome_options)
browser.get("https://www.kingdomofloathing.com/game.php")  # Replace with the correct URL

# Function to find the device path
def find_device_path(device_name):
    devices = [InputDevice(path) for path in list_devices()]
    for device in devices:
        if device_name in device.name:
            return device.path
    return None

DEVICE_PATH = find_device_path("Microsoft X-Box Adaptive Controller")
if DEVICE_PATH is None:
    raise Exception("Could not find the device path for 'Microsoft X-Box Adaptive Controller'")

# Function to find and click a button with a given keyword
def click_keyword(keywords):
    while getattr(threading.currentThread(), "do_run", True):
        for keyword in keywords:
            try:
                # Wait up to 5 seconds for an element with the keyword to appear
                element = WebDriverWait(browser, 5).until(
                    EC.presence_of_element_located((By.XPATH, f"//*[contains(text(), '{keyword}')]"))
                )
                element.click()
                print(f"Clicked element with keyword '{keyword}'.")
                break  # Break the loop after clicking a button
            except Exception as e:
                print(f"Error finding/clicking element with keyword '{keyword}': {e}")
        time.sleep(5)  # Wait a bit before trying again

# Define the event monitoring function
def monitor_input(device_path, keywords):
    device = InputDevice(device_path)
    click_thread = None
    for event in device.read_loop():
        if event.type == ecodes.EV_KEY and event.code == BTN_NORTH:
            if event.value == 1 and (click_thread is None or not click_thread.is_alive()):  # Button pressed
                click_thread = threading.Thread(target=click_keyword, args=(keywords,))
                click_thread.do_run = True
                click_thread.start()
            elif event.value == 0 and click_thread is not None:  # Button released
                click_thread.do_run = False
                click_thread.join()  # Wait for the thread to finish

# Start the input monitoring in a separate thread with a list of keywords
keywords = ["attack", "Play"]  # Add your list of keywords here
input_thread = threading.Thread(target=monitor_input, args=(DEVICE_PATH, keywords))
input_thread.start()

# You may want to handle a graceful exit of the program with try-except or signal handling.
# Don't forget to close the browser when you are done.
try:
    # Keep the main thread alive to handle graceful exit or other actions
    input_thread.join()
except KeyboardInterrupt:
    # Graceful exit on CTRL+C
    print("Exiting...")
    if input_thread.is_alive():
        input_thread.do_run = False
    input_thread.join()
    browser.quit()

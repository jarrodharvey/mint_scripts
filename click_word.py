import cv2
import numpy as np
import pyautogui
import os

def find_and_click_image(image_path, offset=(0, 0)):
    # Take a screenshot of the entire screen
    screenshot = pyautogui.screenshot()
    screen = cv2.cvtColor(np.array(screenshot), cv2.COLOR_RGB2BGR)

    # Load the template image
    template = cv2.imread(image_path, 0)
    template_w, template_h = template.shape[::-1]

    # Convert screenshot to grayscale
    screen_gray = cv2.cvtColor(screen, cv2.COLOR_BGR2GRAY)

    # Perform template matching
    res = cv2.matchTemplate(screen_gray, template, cv2.TM_CCOEFF_NORMED)

    # Set a threshold
    threshold = 0.8
    loc = np.where(res >= threshold)

    # If matches are found, click on the first match
    points = list(zip(*loc[::-1]))  # Get list of points
    if points:
        point = points[0]  # Take the first match
        click_x, click_y = point[0] + template_w/2 + offset[0], point[1] + template_h/2 + offset[1]
        pyautogui.click(click_x, click_y)  # Click the center of the template match with offset if provided
        print(f"Clicked on image '{os.path.basename(image_path)}' at {click_x}, {click_y}")
        return True
    else:
        print(f"Image '{os.path.basename(image_path)}' not found on the screen.")
        return False

# Directory containing images
directory = 'things_to_click'

# Iterate through each image in the directory
for filename in os.listdir(directory):
    if filename.endswith('.png'):
        image_path = os.path.join(directory, filename)
        # Check if the filename is 'th_patrol_again.png'
        if filename == 'th_patrol_again.png':
            found = find_and_click_image(image_path, offset=(150, 0))
        else:
            found = find_and_click_image(image_path)
        if found:
            # If you want to wait between actions, uncomment the following line
            pyautogui.sleep(1)  # Wait for 1 second (or any desired delay)
        else:
            # If no match found, press the Page Down key
            pyautogui.press('pagedown')

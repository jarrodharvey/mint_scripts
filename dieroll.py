import random

def roll_die(num_sides):
    return random.randint(1, num_sides)

energy_level = input("Please enter your current energy level on a scale from 1 to 3: ")

num_sides = int(energy_level) * 3

result = roll_die(num_sides)

print("You rolled a " + str(result))

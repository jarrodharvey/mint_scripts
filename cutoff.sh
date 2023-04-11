#!/bin/bash

echo What are your current energy levels?
echo This covers both your emotional AND physical energy.
echo If you have been drinking socially then pick 2
echo 1: I am exhausted and could not possibly do more work tonight!
echo 2: I have less energy than normal.
echo 3: I feel normal.
echo 4: I have more energy than normal.

read energy_level

if [ $energy_level = 1 ]
then
	echo Whoa! You get the rest of the night off!
	echo BUUUUUUT since you are really that tired - no Pokemon! Anything else but that.
	exit 0
fi

if [ $energy_level = 2 ]
then
	# 1 in 5 chance of having the day/night off to chill
	day_off_chance=26213	
fi

if [ $energy_level = 3 ]
then
	# 1 in 10 chance of having the day/night off to chill
	day_off_chance=29490	
fi

if [ $energy_level = 4 ]
then
	# 1 in 15 chance of having the day/night off to chill
	day_off_chance=30582
fi

# Variable chance of getting the day/night off to chill
# Likelihood depends on energy levels
if [ $RANDOM -gt $day_off_chance ]
then
	echo Make a plan to catch up with friends/family at some point in the future.
	echo Once thats done, take the rest of the day/night off - no cutoff tonight.
	exit 0
fi

echo What time is your alarm set for tomorrow morning?
echo If you do not have an alarm set for tomorrow, type N

read alarm_time

if [ $alarm_time == "N" ]
then
	seconds_to_remove=$(($RANDOM * 2 / $energy_level))
	cutoff=$(date -d "10:00 PM today + $energy_level hours -$seconds_to_remove seconds" +%r)
	bedtime=$(date -d "10:00 PM today + $energy_level hours" +%r)
else
	let bedtime_modifier="($energy_level - 2) * 30" 
	cleaned_alarm_time=$(echo $(date -d "$alarm_time tomorrow" +%r) | sed -E 's/ AE(S|D)T//' )
	bedtime=$(echo $(date -d "$cleaned_alarm_time -9 hours + $bedtime_modifier minutes + 30 minutes" +"%r") | sed -E 's/ AE(S|D)T//' )
	if [ "$1" = "test" ]
	then
		echo The bedtime modifier in minutes is $bedtime_modifier
		echo The initial bedtime check returns $bedtime
		echo The cleaned alarm time is $cleaned_alarm_time
	fi
	seconds_to_remove=$(expr $RANDOM / $energy_level)	
	cutoff=$(date -d "$bedtime today -$seconds_to_remove seconds" +%r)
fi

# Trim the cutoff text
cutoff=${cutoff##*( )}

# What is or is not a late night will vary depending on whether
# I am going in to the office tomorrow and this is determined
# by what time cutoff was last night
echo Are you going in to the office tomorrow?
echo Enter Y or N 

read going_in_to_office 

if [ $going_in_to_office == "N" ]
then
	late_night="11:00 PM"
else
	late_night="9:30 PM"
fi

cutoff_minus_timezone=$( echo $cutoff | sed -E 's/ AE(S|D)T//' )

if [ "$1" = "test" ]
then
	echo Cutoff is currently $cutoff
	echo Cutoff without timezone is currently $cutoff_minus_timezone
	echo Cutoff in unix is currently $( date -d "$cutoff_minus_timezone" '+%s' )
	echo Date is currently $( date '+%s' )
fi

# I will want to do SOME work today...
if [ $( date -d "$cutoff_minus_timezone" '+%s' ) -lt $( date '+%s' ) ]
then
	let minutes_to_work="$energy_level * 25"
	# I am going REALLY easy on myself if I am going in to the office
	# tomorrow and subtracting 30 minutes from cutoff potentially
	if [ $going_in_to_office == "Y" ]
	then
		let minutes_to_work="$minutes_to_work - 30"
	fi
	cutoff=$(date -d "today + $minutes_to_work minutes" +%r)
fi

echo Tonight cutoff is $( date -d "$cutoff_minus_timezone" '+%r' )


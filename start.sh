#!/bin/bash
set -m
python3 RobControl.py &
processing-java --sketch=/Users/PatrickMaloney/Documents/MoonRobotDev/RobotSimulator --run >/dev/null &
fg %1



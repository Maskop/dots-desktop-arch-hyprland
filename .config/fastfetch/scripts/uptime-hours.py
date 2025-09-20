#!/bin/python3
import os
print(f"{round(float(os.popen("cat /proc/uptime").read().split()[0]) / 3600, 2)} hours ({
      round(float(os.popen("cat /proc/uptime").read().split()[0]) / 86400, 2)} days)")

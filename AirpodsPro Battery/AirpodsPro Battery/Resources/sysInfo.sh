#!/usr/local/bin/bash
# sysInfo.sh
SYS_PROFILE=$(system_profiler SPBluetoothDataType 2>/dev/null)
echo $SYS_PROFILE

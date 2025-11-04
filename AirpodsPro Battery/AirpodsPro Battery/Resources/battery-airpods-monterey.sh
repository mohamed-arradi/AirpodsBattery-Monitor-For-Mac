#!/usr/bin/env bash
# Airpods.sh
# Output connected Airpods battery levels via CLI

BT_DEFAULTS=$(defaults read /Library/Preferences/com.apple.Bluetooth)
SYS_PROFILE=$(system_profiler SPBluetoothDataType 2>/dev/null)
MAC_ADDR=$(grep -b2 "Minor Type: "<<<"${SYS_PROFILE}"|awk '/Address/{print $3}')

regex_not_connected='(Not Connected:.+))'
regex_connected='(Connected:.+)'
serialNumbersRegex='Serial Number:[[:space:]]*([^[:space:]]+)[[:space:]]*Serial Number \(Left\):[[:space:]]*([^[:space:]]+)[[:space:]]*Serial Number \(Right\):[[:space:]]*([^[:space:]]+)'

mainSerial=""
leftSerial=""
rightSerial=""

if [[ $SYS_PROFILE =~ $serialNumbersRegex ]]; then
    mainSerial="M--${BASH_REMATCH[1]}"
    leftSerial="L--${BASH_REMATCH[2]}"
    rightSerial="R--${BASH_REMATCH[3]}"
fi

if [[ $SYS_PROFILE =~ $regex_not_connected ]]
then
echo "end"
echo "nc"@@"$mainSerial-$leftSerial-$rightSerial"
exit 0
fi

if [[ $SYS_PROFILE =~ $regex_connected ]]
then

#this regex won't work because of PRCE not working with some bash version (Connected:.Yes).(Vendor ID:.0x004C.)(Product ID:.*(Case.+%).+(Firmware Version:.[A-Z-a-z-0-9]+))
patwithCase="(.+).(Vendor ID:.0x004C.)(Product ID.*(Case.+%))"
patwithoutCase="(.+).(Vendor ID:.0x004C.)(Product ID.*.)"
replace="?"

comp=$(echo ${SYS_PROFILE}  | sed "s/Address:/$replace/g")
set -f
IFS='?'
ary=($comp)
for key in "${!ary[@]}";
do
d=$(echo "${ary[$key]}")
data=""
macAddress=""
connectedStatus=""
vendorID=""
batteryLevel=""
firmwareVersion=""

if [[ $d =~ $patwithCase ]]
then
macAddress=$( echo "${BASH_REMATCH[1]}" | sed 's/ *$//g')
connectedStatus="${BASH_REMATCH[2]}"
vendorID="${BASH_REMATCH[3]}"
data="${BASH_REMATCH[4]}"
firmwareVersion=$(echo ${BASH_REMATCH[6]} | awk '{print $3}')

if [[ $SYS_PROFILE =~ $serialNumbersRegex ]]; then
    mainSerial="M--${BASH_REMATCH[1]}"
    leftSerial="L--${BASH_REMATCH[2]}"
    rightSerial="R--${BASH_REMATCH[3]}"
fi

batterylevelregex="Case Battery Level: (.+%) Left Battery Level: (.+%) Right Battery Level: (.+%)"
batterySingleRegex="(BatteryPercentSingle) = ([0-9]+)"
if [[ $data =~ $batterylevelregex ]]
then
caseBattery="${BASH_REMATCH[1]}"
leftBattery="${BASH_REMATCH[2]}"
rightBattery="${BASH_REMATCH[3]}"
batteryLevel="${caseBattery} ${leftBattery} ${rightBattery}"
if [ -z "$batteryLevel" ]
then
echo ""
else
echo $macAddress"@@""$batteryLevel"@@""$mainSerial-$leftSerial-$rightSerial""
fi
elif [[ $data =~ $batterySingleRegex ]]
then
#IN PROGRESS - AIRPODS MAX (TO VERIFY)
batteryLevel=$macAddress"@@"${BASH_REMATCH[2]}""@@""$mainSerial-$leftSerial-$rightSerial""
echo $batteryLevel
fi
elif [[ $d =~ $patwithoutCase ]]
then
macAddress=$( echo "${BASH_REMATCH[1]}" | sed 's/ *$//g')
vendorID="${BASH_REMATCH[2]}"
data="${BASH_REMATCH[3]}"
firmwareVersion=$(echo ${BASH_REMATCH[6]} | awk '{print $3}')
batterylevelregex="Left Battery Level: (.+%) Right Battery Level: (.+%)"


if [[ $SYS_PROFILE =~ $serialNumbersRegex ]]; then
    mainSerial="M--${BASH_REMATCH[1]}"
    leftSerial="L--${BASH_REMATCH[2]}"
    rightSerial="R--${BASH_REMATCH[3]}"
fi

if [[ $data =~ $batterylevelregex ]]
then

if [[ $SYS_PROFILE =~ $serialNumbersRegex ]]; then
    mainSerial= "${BASH_REMATCH[1]}"
    leftSerial= "${BASH_REMATCH[2]}"
    rightSerial= "${BASH_REMATCH[3]}"
fi

caseBattery="-1"
leftBattery="${BASH_REMATCH[1]}"
rightBattery="${BASH_REMATCH[2]}"
batteryLevel="${caseBattery} ${leftBattery} ${rightBattery}"
if [ -z "$batteryLevel" ]
then
echo ""
else
echo $macAddress"@@""$batteryLevel"@@""$mainSerial-$leftSerial-$rightSerial""
fi
fi
fi
done
else
echo "nc"@@"$mainSerial-$leftSerial-$rightSerial"
fi
exit 0

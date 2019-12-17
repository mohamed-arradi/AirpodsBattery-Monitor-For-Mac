#!/usr/local/bin/bash
  if [ $1 ]; then
    SHORT_MAC_ADDR=$(echo "$1" | awk '{print substr($0,0,8)}')
    result="$(grep -i -A 4 ^"${SHORT_MAC_ADDR}" $2)"
    DEVICE_SELECTED=$(grep -b2 "Apple" <<<"$result" | awk '{print $3}')

    if [ "$result" ]; then
     if [[ $DEVICE_SELECTED = *'Apple'* ]]; then
      echo "1"
    else
      echo "0"
     fi
     else
     echo "0"
    fi
  fi
exit 0

#!/bin/bash
mmsg watch keyboardlayout | while read -r line; do
  C_LAYOUT=$(echo $line |  awk -F'[{}]' '{print $2}')
  CC_LAYOUT=$(echo $C_LAYOUT | cut -d':' -f2)
  if [[ "$CC_LAYOUT" == '"English (US)"' ]]; then
    echo "US"
  else
    echo "IL"
  fi 
done 

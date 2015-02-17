#!/bin/bash

#
# Small script to test the Lua-based forkrate plugin.
# Usage: ./forker.sh <count>
#

times=${1-10}

function child() {
   sleep 5
}

for (( i = 1; i <= $times; i++ )); do
  echo "Forked child " $i
  child &
done
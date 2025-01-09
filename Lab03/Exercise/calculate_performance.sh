#!/bin/bash

# Navigate to 02_SYN folder to read area
cd 02_SYN

# Design name
Design="TETRIS"

# Extract area from the timing report
Area=`cat Report/${Design}.area | grep 'Total cell area:' | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'`

# Navigate to 03_GATE folder to read clock period and execution cycles
cd ../03_GATE

# Clean up and run simulation
./09_clean_up > check.log
./01_run_vcs_gate > check.log

# Check for the result in vcs.log
if grep -i -q 'FAIL' 'vcs.log'; then
    echo -e "\033[31m--- 03_GATE PATTERN Fail !! ---\033[0m"
elif grep -i -q 'Congratulations' 'vcs.log'; then
    echo -e "\033[0;30;42m--- 03_GATE PATTERN PASS !! ---\033[0m"

    # Extract execution cycles and clock period
    Latency=`cat vcs.log | grep 'execution cycles =' | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'`
    ClockPeriod=`cat vcs.log | grep 'clock period =' | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'`

else
    echo -e "\033[31m--- 03_GATE wrong !! ---\033[0m"
    exit 1
fi

# Calculate the performance
Performance=$(echo "$Area * $Latency * $ClockPeriod" | bc -l)

# Display the result with colon alignment
printf "\033[0;30;42m%-18s\033[0m : %s\n" "Area" "$Area"
printf "\033[0;30;42m%-18s\033[0m : %s\n" "Execution cycles" "$Latency"
printf "\033[0;30;42m%-18s\033[0m : %s ns\n" "Clock Period" "$ClockPeriod"
printf "\033[0;30;42m%-18s\033[0m : %.2f\n" "Performance" "$Performance"

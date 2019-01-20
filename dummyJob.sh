#!/bin/bash

if [[ $# -eq 1 ]]; then
    echo "sleep time passed in"
    SLEEP_TIME=$1
    echo "sleeping for $SLEEP_TIME seconds"
    sleep $1
    echo "done sleeping; quitting..."
elif [[ $# -eq 2 ]]; then
    echo "two arguments passed in"
    BEGIN_TIME=$1
    END_TIME=$2
    SLEEP_TIME=$(( END_TIME - BEGIN_TIME ))
    if (( SLEEP_TIME < 0 )); then
        SLEEP_TIME=0
    fi
    echo "sleeping for $SLEEP_TIME seconds"
    sleep $SLEEP_TIME
    echo "done sleeping; quitting..."
else
    echo "wrong arguments passed in"
fi

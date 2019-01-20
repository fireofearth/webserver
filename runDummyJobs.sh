#!/bin/sh

DIR="$HOME/Machines/web/webserver"
PID_FILE="$DIR/pidfile"
SCRIPT_FILE_NAME="job.sh"
SCRIPT_FILE="$DIR/$SCRIPT_FILE_NAME"
OUTPUT_FILE="$DIR/job.out"
DEBUG_FILE=""
MAX_PROCESS=10
NUM_PROCESS=0
PID_LIST=()

# Query whether jobs lauched are still working, or finished
while read -r LINE; do
    QUERY_PID=$LINE
    # Check that the PID exists and name matches the script we called
    QUERY_NAME="$(ps -p $QUERY_PID -o comm=)"
    echo $QUERY_PID
    echo $QUERY_NAME
    if [ "$QUERY_NAME" == "$SCRIPT_FILE_NAME" ]; then
        echo "$QUERY_PID is still running $SCRIPT_FILE_NAME"
        PID_LIST+=($QUERY_PID)
    else
        echo "$QUERY_PID is no longer running or the PID switched to another process"
    fi
done < "$PID_FILE"

NUM_PROCESS=${#PID_LIST[@]}
echo "there are $NUM_PROCESS processes remaining; the ones that are still running are:"
for i in "${!PID_LIST[@]}"; do
    echo "${PID_LIST[i]}"
done

NEW_PROC_TO_RUN=$(($MAX_PROCESS - $NUM_PROCESS))

each 

# Run more jobs if there are available threads
for (( i=1; i<=$NEW_PROC_TO_RUN; i++ )); do
    echo "running scheduler"
    nohup $SCRIPT_FILE $((i*5+5)) &>> $OUTPUT_FILE & 
    JOB_PID=$!
    PID_LIST+=($JOB_PID)
    echo "running pid $JOB_PID with script $JOB_SCRIPT_NAME"
done

# Write the PIDs of the files to the pidfile
PID_FILE="$DIR/pidfile"
rm $PID_FILE
touch $PID_FILE
chmod 664 $PID_FILE
for i in "${!PID_LIST[@]}"; do
    echo "${PID_LIST[i]}" >> $PID_FILE
done

echo "scheduling finished"

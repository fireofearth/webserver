#!/bin/sh

DIR="$HOME/code/web/webserver"
PID_FILE="$DIR/pidfile"
LOCK_FILE="$DIR/lock"
JSON_FILE="$DIR/job_list.json"
SCRIPT_FILE_NAME="job.sh"
SCRIPT_FILE="$DIR/$SCRIPT_FILE_NAME"
OUTPUT_FILE="$DIR/job.out"
DEBUG_FILE=""
MAX_PROCESS=8
NUM_PROCESS=0
PID_LIST=()

function write_pidfile() {
    # Write the PIDs of the files to the pidfile
    PID_FILE="$DIR/pidfile"
    rm $PID_FILE
    touch $PID_FILE
    chmod 664 $PID_FILE
    for i in "${!PID_LIST[@]}"; do
        echo "${PID_LIST[i]}" >> $PID_FILE
    done
}

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

# Check that the file is not being updated  and there
# is at least one entry in the entries array
NUM_JOB_ENTRIES=$(jq '.entries | length' $JSON_FILE)
if [ -f $LOCK_FILE ] || [ $NUM_JOB_ENTRIES -lt 1 ]; then
    echo "can't process jobs. Quitting..."
    write_pidfile
    exit 0
fi
touch $LOCK_FILE

PROC_CAN_RUN=$(($MAX_PROCESS - $NUM_PROCESS))
PROC_TO_RUN=$(($PROC_CAN_RUN < $NUM_JOB_ENTRIES ? $PROC_CAN_RUN : $NUM_JOB_ENTRIES))
echo "there are $NUM_JOB_ENTRIES client job entries, and $PROC_CAN_RUN remaining processors; we will run $PROC_TO_RUN more jobs"

for (( i=1; i<=$PROC_TO_RUN; i++ )); do
    echo "running scheduler"
    # Call the functions, and pass in all the values, trimming the quotation characters
    CLIENT_EMAIL=$(jq ' .entries[0].client_email' $JSON_FILE | tr -d \")
    CLIENT_USERNAME=$(jq ' .entries[0].client_username' $JSON_FILE | tr -d \")
    JOB_NAME=$(jq ' .entries[0].job_name' $JSON_FILE | tr -d \")
    JOB_WEIGHT=$(jq ' .entries[0].job_weight' $JSON_FILE | tr -d \")
    nohup $SCRIPT_FILE $CLIENT_EMAIL $CLIENT_USERNAME $JOB_NAME $JOB_WEIGHT &>> $OUTPUT_FILE & 
    JOB_PID=$!
    PID_LIST+=($JOB_PID)
    jq 'del(.entries[0]) | .' $JSON_FILE >> "${JSON_FILE}_"
    rm $JSON_FILE
    mv "${JSON_FILE}_" $JSON_FILE
    echo "running pid $JOB_PID with script $JOB_SCRIPT_NAME"
done

rm $LOCK_FILE
write_pidfile
echo "scheduling finished"
exit 0


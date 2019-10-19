#!/bin/bash

DIR="$HOME/code/web/webserver"
JOB="$DIR/job"

if [ $# -eq 4 ]; then
    node $JOB $1 $2 $3 $4
else
    echo "wrong arguments passed in"
fi

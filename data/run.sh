#!/usr/bin/env bash

#
# Do nothing if sync destination is not defined
#
if [ -z "$SYNC_DESTINATION" ]; then
    exit 0
fi

#
# Run Unison sync and restart on failure
#

COUNTER=0
${SYNC_RESTART_COUNT:="3"}

if [ ! -d "$SYNC_DESTINATION" ]; then
    echo "Creating sync destination directory..."
    mkdir -p $SYNC_DESTINATION
fi

while [ "$COUNTER" -le "$SYNC_RESTART_COUNT" ]; do
    echo "Starting Unison sync..."
    bg-sync
    [ "$?" -eq "0" ] && exit 0
    echo "Sync exited with $?."
    COUNTER=$((COUNTER + 1))
done

echo "Sync restart limit reached!"
exit 0

#!/bin/bash

# Define the container name
CONTAINER_NAME="big-bear-openvpn-as"

sleep 120

# Check if the container is running
if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then

    # Get the container restart count
    RESTART_COUNT=$(docker inspect --format='{{.RestartCount}}' $CONTAINER_NAME 2>/dev/null)

    # Check if the restart count is greater than 0
    if [ "$RESTART_COUNT" -gt 0 ]; then
        sleep 60
    fi

    # Get the container restart count
    RESTART_COUNT=$(docker inspect --format='{{.RestartCount}}' $CONTAINER_NAME 2>/dev/null)

    # Check if the restart count is greater than 0
    if [ "$RESTART_COUNT" -gt 0 ]; then

        echo "Container $CONTAINER_NAME is restarting. Restarting it now..."

        # Change directory and restart the container
        cd /var/lib/casaos/apps/$CONTAINER_NAME || { echo "Failed to change directory"; exit 1; }
        docker compose stop $CONTAINER_NAME
        docker compose rm -f $CONTAINER_NAME
        docker compose up -d $CONTAINER_NAME

        echo "Container $CONTAINER_NAME has been restarted."
    else
        echo "Container $CONTAINER_NAME is running normally."
    fi

else
    echo "Container $CONTAINER_NAME is not running."
fi
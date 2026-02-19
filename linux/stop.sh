#!/bin/bash
# Stop AWS EC2 Instance

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load configuration from same directory
CONFIG_FILE="$SCRIPT_DIR/config.sh"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file not found: $CONFIG_FILE"
    echo "Please create config.sh in the linux folder with your instance details."
    exit 1
fi

source "$CONFIG_FILE"

# Validate configuration
if [ -z "$INSTANCE_ID" ]; then
    echo "Error: INSTANCE_ID is not set in config.sh"
    exit 1
fi

echo "Stopping EC2 instance: $INSTANCE_ID"

# Stop the instance
if aws ec2 stop-instances --instance-ids "$INSTANCE_ID"; then
    echo "Stop command sent successfully!"
    echo ""
    echo "Waiting for instance to stop..."
    
    # Wait for instance to be stopped
    if aws ec2 wait instance-stopped --instance-ids "$INSTANCE_ID"; then
        echo "Instance has been stopped!"
        echo "Your instance is no longer incurring compute charges."
    else
        echo "Timeout waiting for instance to stop"
        echo "The instance may still be stopping. Check AWS Console for status."
    fi
else
    echo "Failed to stop instance"
    exit 1
fi

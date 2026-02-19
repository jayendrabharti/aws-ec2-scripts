#!/bin/bash
# Start AWS EC2 Instance

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

echo "Starting EC2 instance: $INSTANCE_ID"

# Start the instance
if aws ec2 start-instances --instance-ids "$INSTANCE_ID"; then
    echo "Start command sent successfully!"
    echo ""
    echo "Waiting for instance to be running..."
    
    # Wait for instance to be running
    if aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"; then
        echo "Instance is now running!"
        
        # Get and display public IP
        PUBLIC_IP=$(aws ec2 describe-instances \
            --instance-ids "$INSTANCE_ID" \
            --query 'Reservations[0].Instances[0].PublicIpAddress' \
            --output text)
        
        if [ "$PUBLIC_IP" != "None" ] && [ -n "$PUBLIC_IP" ]; then
            echo "Public IP: $PUBLIC_IP"
            echo ""
            echo "You can now connect using: ./connect.sh"
        fi
    else
        echo "Timeout waiting for instance to start"
    fi
else
    echo "Failed to start instance"
    exit 1
fi

#!/bin/bash
# Connect to AWS EC2 Instance via SSH

set -e  # Exit on error

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Load configuration
CONFIG_FILE="$SCRIPT_DIR/config.sh"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Error: Configuration file not found: $CONFIG_FILE"
    echo "Please copy config.example.sh to config.sh and update it with your values."
    exit 1
fi

source "$CONFIG_FILE"

# Validate configuration
if [ -z "$INSTANCE_ID" ]; then
    echo "❌ Error: INSTANCE_ID is not set in config.sh"
    exit 1
fi

if [ -z "$SSH_KEY_PATH" ]; then
    echo "❌ Error: SSH_KEY_PATH is not set in config.sh"
    exit 1
fi

if [ -z "$SSH_USER" ]; then
    echo "❌ Error: SSH_USER is not set in config.sh"
    exit 1
fi

# Check if SSH key exists
if [ ! -f "$SSH_KEY_PATH" ]; then
    echo "❌ Error: SSH key file not found: $SSH_KEY_PATH"
    exit 1
fi

# Check SSH key permissions
KEY_PERMS=$(stat -c %a "$SSH_KEY_PATH" 2>/dev/null || stat -f %A "$SSH_KEY_PATH" 2>/dev/null)
if [ "$KEY_PERMS" != "400" ] && [ "$KEY_PERMS" != "600" ]; then
    echo "⚠️  Warning: SSH key has insecure permissions ($KEY_PERMS)"
    echo "Setting correct permissions..."
    chmod 400 "$SSH_KEY_PATH"
    echo "✅ Key permissions updated to 400"
fi

# Get EC2 host if not set
if [ -z "$EC2_HOST" ]; then
    echo "🔍 Fetching instance public IP..."
    EC2_HOST=$(aws ec2 describe-instances \
        --instance-ids "$INSTANCE_ID" \
        --query 'Reservations[0].Instances[0].PublicIpAddress' \
        --output text)
    
    if [ "$EC2_HOST" == "None" ] || [ -z "$EC2_HOST" ]; then
        echo "❌ Error: Could not get public IP. Is the instance running?"
        echo "Start it first using: ./scripts/linux/start.sh"
        exit 1
    fi
fi

echo "🔐 Connecting to EC2 instance..."
echo "   Instance: $INSTANCE_ID"
echo "   Host: $EC2_HOST"
echo "   User: $SSH_USER"
echo ""

# Connect via SSH
ssh -i "$SSH_KEY_PATH" "$SSH_USER@$EC2_HOST"

# AWS EC2 Configuration
# Copy this file to config.sh and update with your values

# Your EC2 Instance ID (find it in AWS Console)
INSTANCE_ID="i-0xdxcxdxcxfxcx2xd"

# Path to your SSH private key (.pem file)
SSH_KEY_PATH="./learning-server-key.pem"

# SSH username for your EC2 instance
# Common values: ubuntu, ec2-user, admin
SSH_USER="ubuntu"

# EC2 Public IP or DNS (leave empty to auto-fetch from AWS)
# If empty, the connect script will query AWS for the current public IP
EC2_HOST="13.xxx.xxx.xxx"

# AWS Region (optional, defaults to your AWS CLI config)
# AWS_REGION="ap-south-1"

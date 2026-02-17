# Quick Reference Guide

Quick commands for managing your AWS EC2 instance.

## Windows (PowerShell)

### Daily Operations

```powershell
# Start instance
.\scripts\windows\start.ps1

# Connect to instance
.\scripts\windows\connect.ps1

# Stop instance
.\scripts\windows\stop.ps1
```

### Combined Commands

```powershell
# Start and auto-connect (waits 30 seconds)
.\scripts\windows\start.ps1; Start-Sleep -Seconds 30; .\scripts\windows\connect.ps1
```

## Linux/macOS (Bash)

### Daily Operations

```bash
# Start instance
./scripts/linux/start.sh

# Connect to instance
./scripts/linux/connect.sh

# Stop instance
./scripts/linux/stop.sh
```

### Combined Commands

```bash
# Start and auto-connect (waits 30 seconds)
./scripts/linux/start.sh && sleep 30 && ./scripts/linux/connect.sh

# Stop after disconnecting
# (Just run stop.sh after you exit SSH)
```

## Common AWS CLI Commands

### Instance Status

```bash
# Check instance state
aws ec2 describe-instances --instance-ids YOUR_INSTANCE_ID

# Get just the state
aws ec2 describe-instances \
  --instance-ids YOUR_INSTANCE_ID \
  --query 'Reservations[0].Instances[0].State.Name' \
  --output text
```

### Get Public IP

```bash
aws ec2 describe-instances \
  --instance-ids YOUR_INSTANCE_ID \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text
```

### List All Your Instances

```bash
aws ec2 describe-instances \
  --query 'Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress,Tags[?Key==`Name`].Value|[0]]' \
  --output table
```

### Manual Start/Stop

```bash
# Start
aws ec2 start-instances --instance-ids YOUR_INSTANCE_ID

# Stop
aws ec2 stop-instances --instance-ids YOUR_INSTANCE_ID

# Reboot
aws ec2 reboot-instances --instance-ids YOUR_INSTANCE_ID
```

## SSH Commands

### Basic Connection

```bash
ssh -i path/to/key.pem username@ip-address
```

### With Port Forwarding

```bash
# Forward remote port 8080 to local port 8080
ssh -i key.pem -L 8080:localhost:8080 username@ip-address

# Forward multiple ports
ssh -i key.pem -L 8080:localhost:8080 -L 3000:localhost:3000 username@ip-address
```

### Copy Files (SCP)

```bash
# Copy file TO server
scp -i key.pem local-file.txt username@ip-address:/remote/path/

# Copy file FROM server
scp -i key.pem username@ip-address:/remote/file.txt ./local-path/

# Copy directory recursively
scp -i key.pem -r local-folder/ username@ip-address:/remote/path/
```

### SSH Config (for easier connection)

Create/edit `~/.ssh/config`:

```
Host myserver
    HostName 13.233.226.112
    User ubuntu
    IdentityFile ~/.ssh/learning-server-key.pem
    ServerAliveInterval 60
```

Then connect simply with:

```bash
ssh myserver
```

## Server Commands (once connected)

### System Updates

```bash
# Ubuntu/Debian
sudo apt update && sudo apt upgrade -y

# Amazon Linux
sudo yum update -y
```

### Check System Resources

```bash
# Disk usage
df -h

# Memory usage
free -h

# CPU info
top
# (press 'q' to quit)

# Running processes
ps aux
```

### Common Services

```bash
# Check service status
sudo systemctl status SERVICE_NAME

# Start/stop service
sudo systemctl start SERVICE_NAME
sudo systemctl stop SERVICE_NAME

# Enable service to start on boot
sudo systemctl enable SERVICE_NAME
```

## Cost Tracking

### Monthly Estimate

Check AWS Console → Billing → Bills

### Set Up Billing Alert

1. AWS Console → CloudWatch → Billing
2. Create Alarm
3. Set threshold (e.g., $10/month)
4. Add email notification

### Free Tier Check

AWS Console → Billing → Free Tier

Instance hours remaining: See "EC2 - Compute" section

## Keyboard Shortcuts

### SSH Session

- `Ctrl+C`: Cancel current command
- `Ctrl+D`: Exit SSH session (same as `exit`)
- `Ctrl+L`: Clear screen (same as `clear`)
- `Ctrl+R`: Search command history
- `Ctrl+Z`: Suspend current process

### Terminal/PowerShell

- `Tab`: Auto-complete paths and commands
- `↑/↓`: Navigate command history
- `Ctrl+C`: Cancel current command

## Troubleshooting Quick Fixes

### Can't Connect

```bash
# 1. Check if running
aws ec2 describe-instances --instance-ids YOUR_ID --query 'Reservations[0].Instances[0].State.Name'

# 2. Get current IP
aws ec2 describe-instances --instance-ids YOUR_ID --query 'Reservations[0].Instances[0].PublicIpAddress'

# 3. Test connection
ping YOUR_IP

# 4. Check key permissions (Linux/macOS)
chmod 400 your-key.pem
```

### Forgot to Stop Instance

```bash
# Quick stop command
aws ec2 stop-instances --instance-ids YOUR_INSTANCE_ID
```

### Wrong SSH User

Try these common usernames:

- Ubuntu: `ubuntu`
- Amazon Linux: `ec2-user`
- Debian: `admin`
- RHEL: `ec2-user`

---

**Pro Tip**: Keep this file open in a browser tab for quick reference! 📖

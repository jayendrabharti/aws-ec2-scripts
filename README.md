# AWS EC2 Server Management

A simple toolkit for managing your AWS EC2 instance - start, stop, and connect via SSH with ease.

## 📋 Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Usage](#usage)
  - [Windows (PowerShell)](#windows-powershell)
  - [Linux/macOS (Bash)](#linuxmacos-bash)
- [Project Structure](#project-structure)
- [Troubleshooting](#troubleshooting)

## ✨ Features

- **Start EC2 Instance** - Launch your EC2 instance with a single command
- **Stop EC2 Instance** - Shut down your EC2 instance to save costs
- **SSH Connection** - Connect to your running instance securely
- **Cross-Platform** - Scripts for both Windows (PowerShell) and Linux/macOS (Bash)

## 📦 Prerequisites

Before using these scripts, ensure you have:

1. **AWS CLI** installed and configured
   - Download: https://aws.amazon.com/cli/
   - Run `aws configure` to set up your credentials

2. **SSH Key Pair** (.pem file)
   - Place your EC2 key pair file in a secure location
   - On Linux/macOS: `chmod 400 your-key.pem`

3. **AWS Permissions**
   - Your AWS IAM user must have permissions to:
     - Start/Stop EC2 instances
     - Describe EC2 instances

## 🚀 Quick Start

### 1. Clone or download this repository

```bash
cd aws-ec2-server
```

### 2. Configure your instance details

**For Windows (PowerShell):**

```powershell
# Edit config.ps1 with your details
notepad config.ps1
```

**For Linux/macOS (Bash):**

```bash
# Edit config.sh with your details
nano config.sh
# Make it executable
chmod +x config.sh
```

### 3. Update configuration values

- `INSTANCE_ID`: Your EC2 instance ID (e.g., `i-02ddcddfcaf1c126d`)
- `SSH_KEY_PATH`: Path to your .pem key file
- `SSH_USER`: EC2 username (usually `ec2-user`, `ubuntu`, or `admin`)
- `EC2_HOST`: Your EC2 public IP or DNS (leave blank to auto-fetch)

### 4. Make scripts executable (Linux/macOS only)

```bash
chmod +x scripts/linux/*.sh
```

## ⚙️ Configuration

Create configuration files to avoid hardcoding values in scripts:

**config.ps1** (Windows)

```powershell
$INSTANCE_ID = "i-02ddcddfcaf1c126d"
$SSH_KEY_PATH = "C:\path\to\your-key.pem"
$SSH_USER = "ubuntu"
$EC2_HOST = ""  # Leave empty to auto-fetch
```

**config.sh** (Linux/macOS)

```bash
INSTANCE_ID="i-02ddcddfcaf1c126d"
SSH_KEY_PATH="./your-key.pem"
SSH_USER="ubuntu"
EC2_HOST=""  # Leave empty to auto-fetch
```

> **⚠️ Security Note:** Never commit `config.ps1` or `config.sh` with real credentials to version control!

## 📖 Usage

### Windows (PowerShell)

```powershell
# Start EC2 instance
.\scripts\windows\start.ps1

# Stop EC2 instance
.\scripts\windows\stop.ps1

# Connect via SSH
.\scripts\windows\connect.ps1
```

### Linux/macOS (Bash)

```bash
# Start EC2 instance
./scripts/linux/start.sh

# Stop EC2 instance
./scripts/linux/stop.sh

# Connect via SSH
./scripts/linux/connect.sh
```

## 📁 Project Structure

```
aws-ec2-server/
├── README.md                 # This file
├── config.example.ps1        # Example PowerShell config
├── config.example.sh         # Example Bash config
├── config.ps1               # Your PowerShell config (gitignored)
├── config.sh                # Your Bash config (gitignored)
├── .gitignore               # Ignore sensitive files
├── scripts/
│   ├── windows/             # PowerShell scripts
│   │   ├── start.ps1        # Start EC2 instance
│   │   ├── stop.ps1         # Stop EC2 instance
│   │   └── connect.ps1      # SSH connection
│   └── linux/               # Bash scripts
│       ├── start.sh         # Start EC2 instance
│       ├── stop.sh          # Stop EC2 instance
│       └── connect.sh       # SSH connection
└── docs/
    └── setup-guide.md       # Detailed setup instructions
```

## 🔧 Troubleshooting

### AWS CLI not found

```bash
# Check if AWS CLI is installed
aws --version

# If not installed, visit: https://aws.amazon.com/cli/
```

### Permission denied (public key)

- Verify your SSH key path is correct
- On Linux/macOS, ensure key permissions: `chmod 400 your-key.pem`
- Verify the SSH username matches your EC2 AMI (ubuntu, ec2-user, admin)

### Access Denied when starting/stopping instance

- Check your AWS credentials: `aws configure list`
- Verify your IAM user has EC2 permissions
- Confirm the instance ID is correct

### Instance ID not found

- Verify the instance ID in your config file
- Check the correct AWS region is set: `aws configure get region`

### Connection timeout

- Ensure the instance is running: `aws ec2 describe-instances --instance-ids YOUR_INSTANCE_ID`
- Check your security group allows SSH (port 22) from your IP
- Verify the public IP/DNS is correct

## 💡 Tips

- **Save Costs**: Always stop your instance when not in use
- **Elastic IP**: Consider using an Elastic IP to keep a consistent IP address
- **Scripting**: Chain commands like `./start.sh && sleep 30 && ./connect.sh`
- **Monitoring**: Use `aws ec2 describe-instances` to check instance status

## 📝 License

This project is provided as-is for personal use.

## 🤝 Contributing

Feel free to fork and customize these scripts for your needs!

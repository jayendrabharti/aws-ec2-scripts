# AWS EC2 Server Management

Simple toolkit for managing your AWS EC2 instance - start, stop, and connect via SSH.

## 📋 Quick Start

1. **Configure your settings**
   - Windows: Edit `windows\config.ps1`
   - Linux/macOS: Edit `linux/config.sh`

2. **Update with your details**
   - Instance ID
   - SSH key path
   - SSH username
   - Public IP (optional)

3. **Run the scripts**
   - Windows: `cd windows` then `.\start.ps1`, `.\connect.ps1`, `.\stop.ps1`
   - Linux/macOS: `cd linux` then `./start.sh`, `./connect.sh`, `./stop.sh`

## 📁 Project Structure

```
aws-ec2-server/
├── README.md                    # This file
├── guide.md                     # Detailed setup guide
├── learning-server-key.pem      # Your SSH key (gitignored)
├── windows/                     # Windows PowerShell scripts
│   ├── config.ps1              # Configuration
│   ├── start.ps1               # Start EC2 instance
│   ├── stop.ps1                # Stop EC2 instance
│   └── connect.ps1             # SSH connection
├── linux/                       # Linux/macOS Bash scripts
│   ├── config.sh               # Configuration
│   ├── start.sh                # Start EC2 instance
│   ├── stop.sh                 # Stop EC2 instance
│   └── connect.sh              # SSH connection
└── docs/                        # Additional documentation
    └── quick-reference.md
```

## 📦 Prerequisites

1. **AWS CLI** installed and configured (`aws configure`)
2. **SSH Key Pair** (.pem file) from AWS
3. **AWS Permissions** to start/stop EC2 instances

## ⚙️ Configuration

Configuration files are in each platform folder:

**windows/config.ps1** (Windows)

```powershell
$INSTANCE_ID = "i-your-instance-id"
$SSH_KEY_PATH = "..\learning-server-key.pem"
$SSH_USER = "ubuntu"
$EC2_HOST = ""  # Leave empty to auto-fetch
```

**linux/config.sh** (Linux/macOS)

```bash
INSTANCE_ID="i-your-instance-id"
SSH_KEY_PATH="../learning-server-key.pem"
SSH_USER="ubuntu"
EC2_HOST=""  # Leave empty to auto-fetch
```

## 📖 Usage

### Windows (PowerShell)

```powershell
cd windows

# Start instance
.\start.ps1

# Connect via SSH
.\connect.ps1

# Stop instance
.\stop.ps1
```

### Linux/macOS (Bash)

```bash
# First time: make scripts executable
chmod +x linux/*.sh

cd linux

# Start instance
./start.sh

# Connect via SSH
./connect.sh

# Stop instance
./stop.sh
```

## ✨ Features

- ✅ Auto-fetch public IP if not configured
- ✅ Wait for instance state changes
- ✅ Error handling and validation
- ✅ Color-coded status messages
- ✅ SSH key permission checks (Linux/macOS)
- ✅ Simple, clean structure

## 🔧 Troubleshooting

### AWS CLI not found

```bash
# Check installation
aws --version

# Configure credentials
aws configure
```

### Permission denied (SSH)

```bash
# Linux/macOS: Fix key permissions
chmod 400 learning-server-key.pem

# Verify correct username (ubuntu, ec2-user, admin)
```

### Can't connect

- Ensure instance is running
- Check security group allows SSH from your IP
- Verify instance ID and key path in config
- Try auto-fetch IP (leave EC2_HOST empty)

## 💡 Tips

- **Save Money**: Always stop instance when not in use
- **Quick Access**: Set up shell aliases for common commands
- **Stay Updated**: Run `aws ec2 describe-instances` to check status
- **Security**: Never commit config files with real credentials (they're gitignored)

## 📚 Documentation

- **guide.md** - Complete setup guide from AWS account to first connection
- **docs/quick-reference.md** - Command cheat sheet and useful AWS CLI commands

## 🤝 Common Workflows

**Start and connect:**

```bash
# Windows
cd windows
.\start.ps1
# Wait ~30 seconds
.\connect.ps1

# Linux/macOS
cd linux
./start.sh && sleep 30 && ./connect.sh
```

**Check instance status:**

```bash
aws ec2 describe-instances --instance-ids YOUR_INSTANCE_ID
```

**Get current IP:**

```bash
aws ec2 describe-instances --instance-ids YOUR_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text
```

---

**Happy Computing!** 🚀

For detailed setup instructions, see [guide.md](guide.md)

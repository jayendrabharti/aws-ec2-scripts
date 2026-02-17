# AWS EC2 Management - Setup Guide

This guide will walk you through setting up your AWS EC2 management toolkit from scratch.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [AWS CLI Setup](#aws-cli-setup)
3. [EC2 Instance Setup](#ec2-instance-setup)
4. [Configuring This Toolkit](#configuring-this-toolkit)
5. [First Time Usage](#first-time-usage)
6. [Common Tasks](#common-tasks)
7. [Best Practices](#best-practices)

---

## Prerequisites

Before you begin, you'll need:

- An AWS account with billing enabled
- Administrator access to your computer
- Basic familiarity with command line/terminal

---

## AWS CLI Setup

### 1. Install AWS CLI

#### Windows

1. Download the AWS CLI installer from: https://aws.amazon.com/cli/
2. Run the installer (MSI)
3. Verify installation:
   ```powershell
   aws --version
   ```

#### Linux/macOS

```bash
# macOS (using Homebrew)
brew install awscli

# Linux (using pip)
pip3 install awscli --upgrade --user

# Verify installation
aws --version
```

### 2. Configure AWS CLI

Open terminal/PowerShell and run:

```bash
aws configure
```

You'll be prompted for:

1. **AWS Access Key ID**: Found in AWS Console → IAM → Users → Security Credentials
2. **AWS Secret Access Key**: Provided when you create the access key
3. **Default region**: e.g., `us-east-1`, `ap-south-1`, `eu-west-1`
4. **Default output format**: Use `json`

### 3. Verify AWS CLI

Test your configuration:

```bash
aws sts get-caller-identity
```

You should see your AWS account details.

---

## EC2 Instance Setup

### 1. Create an EC2 Instance

1. Go to AWS Console → EC2 → Instances → Launch Instance
2. Choose an AMI (e.g., Ubuntu 22.04 LTS)
3. Select instance type (e.g., t2.micro for free tier)
4. Configure instance details (use defaults for basic setup)
5. Add storage (default 8GB is usually sufficient)
6. Add tags (optional, but helpful):
   - Key: `Name`, Value: `My Server`
7. Configure Security Group:
   - Allow SSH (port 22) from your IP
   - Add other ports as needed (HTTP: 80, HTTPS: 443)
8. Review and Launch
9. **Create/Select Key Pair**:
   - Choose "Create a new key pair"
   - Name it (e.g., `learning-server-key`)
   - Download the `.pem` file
   - **IMPORTANT**: Save this file securely! You can't download it again.

### 2. Note Your Instance Details

After launching, note down:

- **Instance ID**: e.g., `i-02ddcddfcaf1c126d` (found in EC2 dashboard)
- **Public IP**: Changes each time you start/stop (unless using Elastic IP)
- **SSH Username**: Depends on AMI:
  - Ubuntu: `ubuntu`
  - Amazon Linux: `ec2-user`
  - Debian: `admin`

### 3. Secure Your Key Pair

#### Windows

- Store the `.pem` file in your project folder or a secure location
- No permission changes needed

#### Linux/macOS

```bash
chmod 400 /path/to/your-key.pem
```

---

## Configuring This Toolkit

### 1. Copy Configuration File

#### Windows (PowerShell)

```powershell
Copy-Item config.example.ps1 config.ps1
notepad config.ps1
```

#### Linux/macOS (Bash)

```bash
cp config.example.sh config.sh
nano config.sh  # or use your preferred editor
```

### 2. Update Configuration

Edit the config file with your details:

```bash
# Your EC2 instance ID (from AWS Console)
INSTANCE_ID="i-02ddcddfcaf1c126d"

# Path to your .pem key file
SSH_KEY_PATH="./learning-server-key.pem"

# SSH username (depends on your AMI)
SSH_USER="ubuntu"

# Public IP (optional - leave empty to auto-fetch)
EC2_HOST=""
```

### 3. Place Your Key File

Move your downloaded `.pem` file to the project directory:

```bash
# Linux/macOS
mv ~/Downloads/learning-server-key.pem .
chmod 400 learning-server-key.pem

# Windows
# Just copy the file to your project folder
```

---

## First Time Usage

### Test Each Script

#### Windows

1. **Start Instance**

   ```powershell
   .\scripts\windows\start.ps1
   ```

   Wait for confirmation that instance is running.

2. **Connect to Instance**

   ```powershell
   .\scripts\windows\connect.ps1
   ```

   You should now be connected via SSH!

3. **Exit and Stop Instance**
   ```bash
   exit  # exits SSH connection
   ```
   ```powershell
   .\scripts\windows\stop.ps1
   ```

#### Linux/macOS

1. **Make scripts executable**

   ```bash
   chmod +x scripts/linux/*.sh
   ```

2. **Start Instance**

   ```bash
   ./scripts/linux/start.sh
   ```

3. **Connect to Instance**

   ```bash
   ./scripts/linux/connect.sh
   ```

4. **Exit and Stop**
   ```bash
   exit  # exits SSH connection
   ./scripts/linux/stop.sh
   ```

---

## Common Tasks

### Check Instance Status

```bash
aws ec2 describe-instances --instance-ids YOUR_INSTANCE_ID
```

### Get Current Public IP

```bash
aws ec2 describe-instances \
  --instance-ids YOUR_INSTANCE_ID \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text
```

### Chain Commands

Start and auto-connect (Linux/macOS):

```bash
./scripts/linux/start.sh && sleep 30 && ./scripts/linux/connect.sh
```

Start and auto-connect (Windows):

```powershell
.\scripts\windows\start.ps1; Start-Sleep -Seconds 30; .\scripts\windows\connect.ps1
```

### Use Elastic IP (Recommended)

To avoid changing IPs:

1. AWS Console → EC2 → Elastic IPs → Allocate
2. Associate with your instance
3. Update `EC2_HOST` in your config with the Elastic IP
4. Note: Elastic IPs are free while instance is running, but cost money when instance is stopped

---

## Best Practices

### Cost Optimization

- ✅ **Always stop instances when not in use**
- ✅ Use t2.micro for free tier eligibility
- ✅ Set up billing alerts in AWS Console
- ✅ Use Elastic IP only if needed (it costs money when instance is stopped)

### Security

- ✅ Never share your `.pem` key file
- ✅ Never commit config files with real credentials to Git
- ✅ Use security groups to limit SSH access to your IP only
- ✅ Regularly update your EC2 instance: `sudo apt update && sudo apt upgrade`
- ✅ Use strong passwords for any services you run on the instance

### Maintenance

- ✅ Backup important data regularly
- ✅ Create AMI snapshots before major changes
- ✅ Monitor instance usage in AWS CloudWatch
- ✅ Keep track of your monthly costs

### Troubleshooting

#### Can't connect via SSH

1. Check if instance is running: `aws ec2 describe-instances --instance-ids YOUR_ID`
2. Check security group allows SSH from your IP
3. Verify key file path and permissions
4. Ensure correct username for your AMI

#### AWS CLI command not found

1. Verify installation: `aws --version`
2. On Windows: Restart terminal after installation
3. On Linux/macOS: Check PATH includes AWS CLI location

#### Permission denied (publickey)

1. Verify key file permissions: `chmod 400 your-key.pem`
2. Check SSH username matches your AMI
3. Verify key file path is correct

---

## Additional Resources

- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/)
- [EC2 User Guide](https://docs.aws.amazon.com/ec2/)
- [AWS Free Tier Details](https://aws.amazon.com/free/)
- [EC2 Instance Types](https://aws.amazon.com/ec2/instance-types/)

---

## Need Help?

If you encounter issues:

1. Check the [Troubleshooting section](#troubleshooting)
2. Verify your AWS CLI configuration: `aws configure list`
3. Check AWS Console for instance status
4. Review AWS CloudWatch logs for errors
5. Consult AWS Support or documentation

---

**Happy Computing! 🚀**

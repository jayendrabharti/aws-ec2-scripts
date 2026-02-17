# Migration Guide - Old Structure to New

If you were using the old flat structure, here's how to migrate to the new organized structure.

## What Changed?

### Old Structure ❌

```
aws-ec2-server/
├── start.ps1
├── stop.ps1
├── connect.ps1
├── start.sh
├── stop.sh
├── connect.sh
└── guide.md
```

### New Structure ✅

```
aws-ec2-server/
├── README.md                 # Comprehensive documentation
├── guide.md                  # Detailed setup guide
├── .gitignore               # Protects sensitive files
├── config.example.ps1       # PowerShell config template
├── config.example.sh        # Bash config template
├── config.ps1              # Your actual config (gitignored)
├── config.sh               # Your actual config (gitignored)
├── scripts/
│   ├── windows/
│   │   ├── start.ps1
│   │   ├── stop.ps1
│   │   └── connect.ps1
│   └── linux/
│       ├── start.sh
│       ├── stop.sh
│       └── connect.sh
└── docs/
    └── quick-reference.md   # Quick command reference
```

## Migration Steps

### 1. Update Your Commands

**Old Windows Commands:**

```powershell
.\start.ps1
.\stop.ps1
.\connect.ps1
```

**New Windows Commands:**

```powershell
.\scripts\windows\start.ps1
.\scripts\windows\stop.ps1
.\scripts\windows\connect.ps1
```

**Old Linux/macOS Commands:**

```bash
./start.sh
./stop.sh
./connect.sh
```

**New Linux/macOS Commands:**

```bash
./scripts/linux/start.sh
./scripts/linux/stop.sh
./scripts/linux/connect.sh
```

### 2. Configure Your Settings

The new scripts use configuration files instead of hardcoded values.

**Create your config file:**

```bash
# Windows
Copy-Item config.example.ps1 config.ps1

# Linux/macOS
cp config.example.sh config.sh
```

**Edit with your details:**

- `INSTANCE_ID`: Your EC2 instance ID
- `SSH_KEY_PATH`: Path to your .pem file
- `SSH_USER`: Your SSH username
- `EC2_HOST`: Your EC2 IP (or leave empty to auto-fetch)

### 3. Benefits of New Structure

✅ **Better Organization**: Scripts organized by platform  
✅ **Configuration Management**: Separate config files (not committed to git)  
✅ **Enhanced Features**:

- Automatic IP fetching
- Error handling and validation
- Status messages with color coding
- Wait for instance state changes

✅ **Better Documentation**: Comprehensive guides and quick reference  
✅ **Security**: .gitignore prevents accidental credential commits

## New Features

### Improved Scripts

The new scripts include:

- ✅ Configuration validation
- ✅ Error handling
- ✅ Status messages
- ✅ Auto-fetching of public IP
- ✅ Waiting for instance state changes
- ✅ SSH key permission checks (Linux/macOS)

### Better Documentation

- **README.md**: Project overview and quick start
- **guide.md**: Detailed setup with troubleshooting
- **quick-reference.md**: Command cheat sheet

## Optional: Update Aliases/Shortcuts

If you created shortcuts or aliases for the old scripts, update them:

### PowerShell Profile

Edit `$PROFILE` (run `notepad $PROFILE`):

```powershell
# Old
function ec2start { .\start.ps1 }

# New
function ec2start { .\scripts\windows\start.ps1 }
```

### Bash Aliases

Edit `~/.bashrc` or `~/.zshrc`:

```bash
# Old
alias ec2start='./start.sh'

# New
alias ec2start='./scripts/linux/start.sh'
alias ec2stop='./scripts/linux/stop.sh'
alias ec2connect='./scripts/linux/connect.sh'
```

Then reload: `source ~/.bashrc`

## Need Help?

Refer to:

- [README.md](../README.md) for overview
- [guide.md](../guide.md) for detailed setup
- [quick-reference.md](docs/quick-reference.md) for commands

---

**Note**: The old flat structure scripts have been removed. All functionality is now in the organized `scripts/` directory.

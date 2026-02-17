# Connect to AWS EC2 Instance via SSH

# Error handling
$ErrorActionPreference = "Stop"

# Get script directory
$ScriptDir = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if (-not $ScriptDir) {
    $ScriptDir = (Get-Location).Path
}

# Load configuration
$ConfigFile = Join-Path $ScriptDir "config.ps1"
if (-not (Test-Path $ConfigFile)) {
    Write-Host "❌ Error: Configuration file not found: $ConfigFile" -ForegroundColor Red
    Write-Host "Please copy config.example.ps1 to config.ps1 and update it with your values." -ForegroundColor Yellow
    exit 1
}

. $ConfigFile

# Validate configuration
if (-not $INSTANCE_ID) {
    Write-Host "❌ Error: INSTANCE_ID is not set in config.ps1" -ForegroundColor Red
    exit 1
}

if (-not $SSH_KEY_PATH) {
    Write-Host "❌ Error: SSH_KEY_PATH is not set in config.ps1" -ForegroundColor Red
    exit 1
}

if (-not $SSH_USER) {
    Write-Host "❌ Error: SSH_USER is not set in config.ps1" -ForegroundColor Red
    exit 1
}

# Check if SSH key exists
if (-not (Test-Path $SSH_KEY_PATH)) {
    Write-Host "❌ Error: SSH key file not found: $SSH_KEY_PATH" -ForegroundColor Red
    exit 1
}

# Get EC2 host if not set
if (-not $EC2_HOST) {
    Write-Host "🔍 Fetching instance public IP..." -ForegroundColor Yellow
    $EC2_HOST = aws ec2 describe-instances `
        --instance-ids $INSTANCE_ID `
        --query 'Reservations[0].Instances[0].PublicIpAddress' `
        --output text
    
    if (-not $EC2_HOST -or $EC2_HOST -eq "None") {
        Write-Host "❌ Error: Could not get public IP. Is the instance running?" -ForegroundColor Red
        Write-Host "Start it first using: .\scripts\windows\start.ps1" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "🔐 Connecting to EC2 instance..." -ForegroundColor Cyan
Write-Host "   Instance: $INSTANCE_ID" -ForegroundColor White
Write-Host "   Host: $EC2_HOST" -ForegroundColor White
Write-Host "   User: $SSH_USER" -ForegroundColor White
Write-Host ""

# Connect via SSH
ssh -i $SSH_KEY_PATH "$SSH_USER@$EC2_HOST"

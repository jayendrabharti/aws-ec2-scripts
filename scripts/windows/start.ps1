# Start AWS EC2 Instance

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

Write-Host "🚀 Starting EC2 instance: $INSTANCE_ID" -ForegroundColor Cyan

try {
    # Start the instance
    aws ec2 start-instances --instance-ids $INSTANCE_ID
    Write-Host "✅ Start command sent successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "⏳ Waiting for instance to be running..." -ForegroundColor Yellow
    
    # Wait for instance to be running
    aws ec2 wait instance-running --instance-ids $INSTANCE_ID
    Write-Host "✅ Instance is now running!" -ForegroundColor Green
    
    # Get and display public IP
    $PublicIP = aws ec2 describe-instances `
        --instance-ids $INSTANCE_ID `
        --query 'Reservations[0].Instances[0].PublicIpAddress' `
        --output text
    
    if ($PublicIP -and $PublicIP -ne "None") {
        Write-Host "📍 Public IP: $PublicIP" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "You can now connect using: .\scripts\windows\connect.ps1" -ForegroundColor White
    }
}
catch {
    Write-Host "❌ Failed to start instance: $_" -ForegroundColor Red
    exit 1
}

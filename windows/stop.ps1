# Stop AWS EC2 Instance

$ErrorActionPreference = "Stop"

# Load configuration from same directory
$ConfigFile = Join-Path $PSScriptRoot "config.ps1"
if (-not (Test-Path $ConfigFile)) {
    Write-Host "Error: Configuration file not found: $ConfigFile" -ForegroundColor Red
    Write-Host "Please create config.ps1 in the windows folder with your instance details." -ForegroundColor Yellow
    exit 1
}

. $ConfigFile

# Validate configuration
if (-not $INSTANCE_ID) {
    Write-Host "Error: INSTANCE_ID is not set in config.ps1" -ForegroundColor Red
    exit 1
}

Write-Host "Stopping EC2 instance: $INSTANCE_ID" -ForegroundColor Cyan

try {
    # Stop the instance
    aws ec2 stop-instances --instance-ids $INSTANCE_ID
    Write-Host "Stop command sent successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Waiting for instance to stop..." -ForegroundColor Yellow
    
    # Wait for instance to be stopped
    aws ec2 wait instance-stopped --instance-ids $INSTANCE_ID
    Write-Host "Instance has been stopped!" -ForegroundColor Green
    Write-Host "Your instance is no longer incurring compute charges." -ForegroundColor Green
}
catch {
    Write-Host "Failed to stop instance: $_" -ForegroundColor Red
    Write-Host "The instance may still be stopping. Check AWS Console for status." -ForegroundColor Yellow
    exit 1
}

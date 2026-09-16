# Quick script to verify Java installation
Write-Host "Checking Java installation..." -ForegroundColor Cyan
Write-Host ""

try {
    $javaVersion = java -version 2>&1
    Write-Host "✅ Java is installed!" -ForegroundColor Green
    Write-Host $javaVersion
    Write-Host ""
    Write-Host "✅ Ready to build Android APK!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next step: Run the build script" -ForegroundColor Yellow
    Write-Host "  .\build-and-install.ps1" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Java not found!" -ForegroundColor Red
    Write-Host "Please install JDK 17 and restart PowerShell" -ForegroundColor Yellow
}

# EcoBridge Android Build & Install Script
# This script builds the frontend, syncs with Capacitor, builds the APK, and installs it on a connected device

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "   EcoBridge Android Build & Install  " -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Check if Java is installed
Write-Host "🔍 Checking prerequisites..." -ForegroundColor Yellow
try {
    $javaVersion = java -version 2>&1 | Select-String "version"
    Write-Host "✅ Java installed: $javaVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Java (JDK) not found!" -ForegroundColor Red
    Write-Host "Please install JDK 17 from: https://adoptium.net/temurin/releases/" -ForegroundColor Yellow
    Write-Host "See ANDROID_BUILD_GUIDE.md for detailed instructions." -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Step 1: Build frontend
Write-Host "📦 Step 1/4: Building frontend..." -ForegroundColor Cyan
Set-Location frontend
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Frontend build failed!" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Frontend built successfully" -ForegroundColor Green
Write-Host ""

# Step 2: Sync with Capacitor
Write-Host "🔄 Step 2/4: Syncing with Capacitor..." -ForegroundColor Cyan
Set-Location ..
npx cap sync android
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Capacitor sync failed!" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Capacitor sync completed" -ForegroundColor Green
Write-Host ""

# Step 3: Build APK
Write-Host "🤖 Step 3/4: Building Android APK..." -ForegroundColor Cyan
Write-Host "   (This may take 1-5 minutes on first build)" -ForegroundColor Yellow
Set-Location android
.\gradlew assembleDebug
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ APK build failed!" -ForegroundColor Red
    Write-Host "Check ANDROID_BUILD_GUIDE.md for troubleshooting." -ForegroundColor Yellow
    exit 1
}
Write-Host "✅ APK built successfully" -ForegroundColor Green
Write-Host ""

# Return to root
Set-Location ..

# APK location
$apkPath = "android\app\build\outputs\apk\debug\app-debug.apk"
$apkFullPath = Resolve-Path $apkPath
$apkSize = (Get-Item $apkPath).Length / 1MB
Write-Host "📦 APK Location: $apkFullPath" -ForegroundColor Green
Write-Host "📊 APK Size: $([math]::Round($apkSize, 2)) MB" -ForegroundColor Green
Write-Host ""

# Step 4: Check if device connected and install
Write-Host "📱 Step 4/4: Installing on device..." -ForegroundColor Cyan

# Check if adb is available
try {
    $adbCheck = adb version 2>&1
    Write-Host "✅ ADB found" -ForegroundColor Green
} catch {
    Write-Host "❌ ADB not found!" -ForegroundColor Red
    Write-Host "Please install Android SDK Platform Tools." -ForegroundColor Yellow
    Write-Host "APK saved at: $apkFullPath" -ForegroundColor Yellow
    Write-Host "You can install it manually by copying to your phone." -ForegroundColor Yellow
    exit 0
}

# Check for connected devices
$devices = adb devices 2>&1 | Select-String -Pattern "\tdevice$"
if ($devices.Count -eq 0) {
    Write-Host "⚠️ No device connected via USB" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "To install on your phone:" -ForegroundColor Yellow
    Write-Host "1. Enable USB Debugging on your phone" -ForegroundColor White
    Write-Host "   Settings → About Phone → Tap 'Build Number' 7 times" -ForegroundColor White
    Write-Host "   Settings → System → Developer Options → Enable USB Debugging" -ForegroundColor White
    Write-Host ""
    Write-Host "2. Connect your phone via USB cable" -ForegroundColor White
    Write-Host ""
    Write-Host "3. Run this script again, or install manually:" -ForegroundColor White
    Write-Host "   adb install -r $apkPath" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "OR copy the APK to your phone and install from there:" -ForegroundColor White
    Write-Host "   $apkFullPath" -ForegroundColor Cyan
    Write-Host ""
    exit 0
}

# Device connected - install
Write-Host "✅ Device connected!" -ForegroundColor Green
Write-Host "📲 Installing APK..." -ForegroundColor Yellow

adb install -r $apkPath
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Installation failed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Common solutions:" -ForegroundColor Yellow
    Write-Host "1. Uninstall old version: adb uninstall com.ecobridge.app" -ForegroundColor White
    Write-Host "2. Check phone screen for installation prompt" -ForegroundColor White
    Write-Host "3. Try installing manually from phone's file manager" -ForegroundColor White
    exit 1
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Green
Write-Host "✅ EcoBridge installed successfully!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""
Write-Host "🎉 Open the app on your phone to test!" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 Testing Checklist:" -ForegroundColor Yellow
Write-Host "  • App launches without crashes" -ForegroundColor White
Write-Host "  • Splash screen displays" -ForegroundColor White
Write-Host "  • Language selection works" -ForegroundColor White
Write-Host "  • Login screen works" -ForegroundColor White
Write-Host "  • NEW: Role selection → Seller Type → User Info" -ForegroundColor White
Write-Host "  • NEW: Role selection → Recycler Type → GST Entry" -ForegroundColor White
Write-Host "  • NEW: Badge/label appears on main screen" -ForegroundColor White
Write-Host ""
Write-Host "📖 See ANDROID_BUILD_GUIDE.md for detailed testing checklist" -ForegroundColor Cyan
Write-Host ""

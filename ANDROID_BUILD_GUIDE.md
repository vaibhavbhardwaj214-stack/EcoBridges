# 📱 Android APK Build & Installation Guide

## ✅ Current Status
- ✅ Frontend built successfully (dist folder created)
- ✅ Capacitor sync completed (Android assets updated)
- ❌ Java JDK not installed (required for building APK)

---

## 🛠️ Prerequisites Installation

### 1. Install Java Development Kit (JDK) 17

**Option A: Using Chocolatey (Recommended)**
```powershell
# Run PowerShell as Administrator
choco install openjdk17
```

**Option B: Manual Download**
1. Download JDK 17 from: https://adoptium.net/temurin/releases/
2. Choose:
   - Version: 17 (LTS)
   - Operating System: Windows
   - Architecture: x64
   - Package Type: JDK
3. Run installer and follow prompts
4. Make sure "Set JAVA_HOME variable" is checked during installation

**Verify Installation:**
```powershell
java -version
# Should show: openjdk version "17.x.x"
```

### 2. Install Android Studio (Optional but Recommended)

**Download**: https://developer.android.com/studio

This installs Android SDK automatically and provides:
- Android SDK Platform Tools (includes `adb` for USB debugging)
- Android Virtual Device (AVD) for testing
- Full IDE if you want to debug native code

**After Installation:**
1. Open Android Studio
2. Go to: Tools → SDK Manager
3. Install:
   - ✅ Android SDK Platform 34 (or latest)
   - ✅ Android SDK Build-Tools
   - ✅ Android SDK Command-line Tools
   - ✅ Android SDK Platform-Tools

---

## 🏗️ Build the APK

### Method 1: Using NPM Script (Easiest)

```powershell
# From project root
cd C:\Users\vaibh\Downloads\ecobridge

# Build debug APK (for testing)
pnpm run build:apk

# OR build release APK (for distribution)
pnpm run build:apk:release
```

### Method 2: Manual Steps

```powershell
# Step 1: Build frontend
cd frontend
npm run build

# Step 2: Sync with Android
cd ..
npx cap sync android

# Step 3: Build APK
cd android
.\gradlew assembleDebug

# For release APK:
.\gradlew assembleRelease
```

---

## 📦 APK Location

After successful build, your APK will be at:

**Debug APK**:
```
C:\Users\vaibh\Downloads\ecobridge\android\app\build\outputs\apk\debug\app-debug.apk
```

**Release APK**:
```
C:\Users\vaibh\Downloads\ecobridge\android\app\build\outputs\apk\release\app-release-unsigned.apk
```

**APK Size**: ~8-15 MB (debug), ~5-8 MB (release, unsigned)

---

## 📲 Install APK on Phone via USB

### Step 1: Enable Developer Options on Your Phone

1. Go to **Settings** → **About Phone**
2. Tap **Build Number** 7 times
3. You'll see "You are now a developer!"

### Step 2: Enable USB Debugging

1. Go to **Settings** → **System** → **Developer Options**
2. Enable **USB Debugging**
3. Enable **Install via USB** (if available)

### Step 3: Connect Phone to PC

1. Connect your phone via USB cable
2. Phone will prompt: "Allow USB debugging?"
3. Check "Always allow from this computer"
4. Tap **OK**

### Step 4: Verify Connection

```powershell
# Check if device is recognized
adb devices

# Should show:
# List of devices attached
# XXXXXXXXXXXXX    device
```

**If `adb` not found:**
- Install Android Studio (includes SDK Platform Tools)
- OR download just Platform Tools: https://developer.android.com/tools/releases/platform-tools
- Add to PATH: `C:\Users\vaibh\AppData\Local\Android\Sdk\platform-tools`

### Step 5: Install APK

**Method A: Using ADB (Recommended)**
```powershell
cd C:\Users\vaibh\Downloads\ecobridge

# Install debug APK
adb install android\app\build\outputs\apk\debug\app-debug.apk

# OR install release APK
adb install android\app\build\outputs\apk\release\app-release-unsigned.apk

# To reinstall (if already installed):
adb install -r android\app\build\outputs\apk\debug\app-debug.apk
```

**Method B: File Transfer**
1. Copy APK file to phone's Download folder
2. Open **File Manager** on phone
3. Navigate to **Downloads**
4. Tap the APK file
5. Tap **Install**
6. Grant "Install unknown apps" permission if prompted

**Method C: Drag & Drop (Windows File Explorer)**
1. Connect phone via USB
2. Open phone in File Explorer
3. Drag APK to phone's Download folder
4. Follow Method B steps 2-6

---

## 🚀 Quick Setup Script

Save this as `build-and-install.ps1`:

```powershell
# EcoBridge Android Build & Install Script
Write-Host "🏗️ Building EcoBridge APK..." -ForegroundColor Cyan

# Step 1: Build frontend
Write-Host "`n📦 Building frontend..." -ForegroundColor Yellow
cd frontend
npm run build
if ($LASTEXITCODE -ne 0) { Write-Host "❌ Frontend build failed" -ForegroundColor Red; exit 1 }

# Step 2: Sync with Capacitor
Write-Host "`n🔄 Syncing with Capacitor..." -ForegroundColor Yellow
cd ..
npx cap sync android
if ($LASTEXITCODE -ne 0) { Write-Host "❌ Capacitor sync failed" -ForegroundColor Red; exit 1 }

# Step 3: Build APK
Write-Host "`n🤖 Building Android APK..." -ForegroundColor Yellow
cd android
.\gradlew assembleDebug
if ($LASTEXITCODE -ne 0) { Write-Host "❌ APK build failed" -ForegroundColor Red; exit 1 }

# Step 4: Check if device connected
Write-Host "`n📱 Checking for connected device..." -ForegroundColor Yellow
$devices = adb devices | Select-String -Pattern "device$"
if ($devices.Count -eq 0) {
    Write-Host "❌ No device connected. Please connect your phone via USB." -ForegroundColor Red
    Write-Host "📋 APK location: android\app\build\outputs\apk\debug\app-debug.apk" -ForegroundColor Green
    exit 0
}

# Step 5: Install on device
Write-Host "`n📲 Installing APK on device..." -ForegroundColor Yellow
cd ..
adb install -r android\app\build\outputs\apk\debug\app-debug.apk
if ($LASTEXITCODE -ne 0) { Write-Host "❌ Installation failed" -ForegroundColor Red; exit 1 }

Write-Host "`n✅ EcoBridge installed successfully!" -ForegroundColor Green
Write-Host "🎉 Open the app on your phone to test the new onboarding flow!" -ForegroundColor Cyan
```

**Run it:**
```powershell
cd C:\Users\vaibh\Downloads\ecobridge
.\build-and-install.ps1
```

---

## 🐛 Troubleshooting

### Issue: "JAVA_HOME is not set"

**Solution:**
```powershell
# Set JAVA_HOME (replace with your JDK path)
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-17.0.x-hotspot"
$env:PATH += ";$env:JAVA_HOME\bin"

# Or permanently (run PowerShell as Administrator):
[System.Environment]::SetEnvironmentVariable('JAVA_HOME', 'C:\Program Files\Eclipse Adoptium\jdk-17.0.x-hotspot', 'Machine')
```

### Issue: "adb: command not found"

**Solution:**
```powershell
# Add Android SDK Platform Tools to PATH
$env:PATH += ";C:\Users\vaibh\AppData\Local\Android\Sdk\platform-tools"

# Or permanently (run PowerShell as Administrator):
$oldPath = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine')
$newPath = "$oldPath;C:\Users\vaibh\AppData\Local\Android\Sdk\platform-tools"
[System.Environment]::SetEnvironmentVariable('PATH', $newPath, 'Machine')
```

### Issue: "Device not recognized"

**Solutions:**
1. Try different USB cable (some cables are charge-only)
2. Try different USB port
3. Install phone manufacturer's USB drivers:
   - Samsung: Smart Switch
   - Google Pixel: Google USB Driver
   - OnePlus: OnePlus USB Drivers
4. Check "Select USB Configuration" on phone:
   - Settings → Developer Options → Select USB Configuration
   - Choose "File Transfer (MTP)" or "PTP"

### Issue: "Installation failed: INSTALL_FAILED_UPDATE_INCOMPATIBLE"

**Solution:**
```powershell
# Uninstall old version first
adb uninstall com.ecobridge.app

# Then reinstall
adb install android\app\build\outputs\apk\debug\app-debug.apk
```

### Issue: "App crashes on launch"

**Check logs:**
```powershell
# View real-time logs
adb logcat | Select-String "ecobridge"

# Or save to file
adb logcat > app-logs.txt
```

### Issue: Build takes too long

**Speed up Gradle builds:**

Edit `android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx4096m -XX:MaxMetaspaceSize=512m
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.configureondemand=true
android.enableJetifier=true
android.useAndroidX=true
```

---

## 📊 Build Time Estimates

- **First build**: 5-15 minutes (downloads dependencies)
- **Subsequent builds**: 1-3 minutes
- **Frontend only**: 10-30 seconds
- **APK installation**: 10-30 seconds

---

## ✅ Testing Checklist

After installing APK on your phone:

### Fresh Install Testing
- [ ] App launches without crashes
- [ ] Splash screen displays correctly
- [ ] Language selection works
- [ ] Onboarding carousel works
- [ ] Login screen works
- [ ] Phone verification works

### New Onboarding Flow Testing
- [ ] **Role Selection**: Choose "Vendor/Seller"
- [ ] **Seller Type**: Choose "User/Firm" or "Vendor"
- [ ] **User Info**: Complete profile
- [ ] **Main Screen**: Verify correct label appears ("User/Firm" or "Vendor")

- [ ] **Role Selection**: Choose "Recycler/Collector"
- [ ] **Recycler Type**: Choose "Authorized"
- [ ] **GST Screen**: Enter valid GST (22AAAAA0000A1Z5)
- [ ] **User Info**: Complete profile
- [ ] **Main Screen**: Verify ⭐ star badge appears

- [ ] **Recycler Type**: Choose "Non Authorized"
- [ ] **User Info**: GST screen skipped
- [ ] **Main Screen**: No badge (identical to authorized layout)

### Multi-Language Testing
- [ ] Change language to Hindi
- [ ] All screens translate correctly
- [ ] Change language to Marathi
- [ ] All screens translate correctly

### Performance Testing
- [ ] App loads in < 3 seconds
- [ ] Navigation is smooth (no lag)
- [ ] No memory leaks (use for 5+ minutes)
- [ ] Battery usage is reasonable

---

## 🎯 Next Steps

After successful testing:

1. **Create Release APK** (for distribution):
   ```powershell
   pnpm run build:apk:release
   ```

2. **Sign APK** (required for Play Store):
   - Generate signing key
   - Sign the release APK
   - See: https://developer.android.com/studio/publish/app-signing

3. **Optimize APK**:
   - Enable ProGuard (code minification)
   - Enable R8 (code shrinking)
   - Optimize images
   - Split APKs by architecture

4. **Deploy to Play Store**:
   - Create developer account ($25 one-time fee)
   - Upload signed APK
   - Fill store listing details
   - Publish!

---

## 📞 Quick Reference

### Commands Cheat Sheet

```powershell
# Build everything
pnpm run build:apk

# Just build frontend
cd frontend; npm run build

# Just sync Android
npx cap sync android

# Just build APK
cd android; .\gradlew assembleDebug

# Check connected devices
adb devices

# Install APK
adb install path\to\app-debug.apk

# Reinstall APK
adb install -r path\to\app-debug.apk

# Uninstall app
adb uninstall com.ecobridge.app

# View logs
adb logcat

# Clear app data
adb shell pm clear com.ecobridge.app

# Open Android Studio
npx cap open android
```

### File Locations

- **Frontend Build**: `frontend/dist/`
- **Android Assets**: `android/app/src/main/assets/public/`
- **Debug APK**: `android/app/build/outputs/apk/debug/app-debug.apk`
- **Release APK**: `android/app/build/outputs/apk/release/app-release-unsigned.apk`
- **Gradle Config**: `android/build.gradle`, `android/app/build.gradle`
- **Capacitor Config**: `capacitor.config.json`

---

## 🎉 Summary

**To build and install your app:**

1. **Install JDK 17**: https://adoptium.net/temurin/releases/
2. **Install Android SDK**: https://developer.android.com/studio
3. **Build APK**: `pnpm run build:apk`
4. **Enable USB Debugging** on your phone
5. **Connect phone** via USB
6. **Install APK**: `adb install android\app\build\outputs\apk\debug\app-debug.apk`
7. **Test the new onboarding flow!** 🎊

---

**Document Version**: 1.0  
**Last Updated**: 2026-09-09  
**Status**: Ready for Build  
**Estimated Time**: 20-30 minutes (first time)

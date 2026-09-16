# 🚀 Quick Start - Install EcoBridge on Your Phone

## What You Need (First Time Only)

1. **Java JDK 17** - Download: https://adoptium.net/temurin/releases/
   - Choose: Windows x64, JDK, Version 17
   - Install and make sure "Set JAVA_HOME" is checked

2. **Android SDK Platform Tools** (for `adb` command)
   - **Option A**: Install full Android Studio: https://developer.android.com/studio
   - **Option B**: Just Platform Tools: https://developer.android.com/tools/releases/platform-tools
   - Extract and add to PATH: `C:\...\platform-tools`

## 📲 Install on Your Phone (3 Steps)

### Step 1: Enable USB Debugging on Phone

1. Go to **Settings** → **About Phone**
2. Tap **Build Number** 7 times (you'll see "You are now a developer!")
3. Go to **Settings** → **System** → **Developer Options**
4. Enable **USB Debugging**

### Step 2: Build & Install

```powershell
# Connect your phone via USB
# Then run:
cd C:\Users\vaibh\Downloads\ecobridge
.\build-and-install.ps1
```

This script will:
- ✅ Build the frontend
- ✅ Sync with Android
- ✅ Build APK
- ✅ Install on your phone automatically

**Time**: ~2-5 minutes

### Step 3: Test on Phone

Open the app and test the new onboarding flow:

✅ **Seller Flow**: Role → Seller Type → User Info → Main (with label)  
✅ **Recycler Flow**: Role → Recycler Type → GST → User Info → Main (with ⭐)

---

## 🔧 Troubleshooting

### "Java not found"
```powershell
# Install JDK 17 from: https://adoptium.net/temurin/releases/
# Then restart PowerShell
```

### "adb not found"
```powershell
# Add Platform Tools to PATH:
$env:PATH += ";C:\Users\vaibh\AppData\Local\Android\Sdk\platform-tools"
```

### "No device connected"
- Use a data cable (not charge-only)
- Check phone screen for "Allow USB debugging?" prompt
- Try different USB port

### "Installation failed"
```powershell
# Uninstall old version first:
adb uninstall com.ecobridge.app
# Then run build script again
```

---

## 📖 More Help

- **Full Guide**: See `ANDROID_BUILD_GUIDE.md`
- **Feature Docs**: See `SELLER_RECYCLER_ONBOARDING_IMPLEMENTATION_COMPLETE.md`
- **Spec Folder**: `.kiro/specs/seller-recycler-onboarding-flow/`

---

## 🎯 That's It!

Your phone now has the latest EcoBridge app with the new seller-recycler onboarding flow! 🎉

**Questions?** Check the guides above or ask for help.

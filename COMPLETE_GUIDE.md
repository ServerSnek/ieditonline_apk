# 🎯 Complete Guide: Create APK from React Native WebView App

## Overview
This guide will help you create an Android APK file from the React Native app that displays https://staging.ieditonline.com in a WebView.

---

## 📋 Table of Contents
1. [Prerequisites Installation](#prerequisites-installation)
2. [Project Setup](#project-setup)
3. [Building Debug APK](#building-debug-apk)
4. [Building Release APK](#building-release-apk)
5. [Installing APK on Device](#installing-apk-on-device)
6. [Troubleshooting](#troubleshooting)

---

## Prerequisites Installation

### Step 1: Install Node.js

1. Visit https://nodejs.org/
2. Download the **LTS version** (v18 or higher)
3. Run the installer
4. Verify installation:
   ```bash
   node --version
   npm --version
   ```

### Step 2: Fix npm Cache (Important!)

Run this command to fix permission issues:
```bash
sudo chown -R $(whoami) ~/.npm
```

### Step 3: Install Java JDK 17

1. Visit https://www.oracle.com/java/technologies/downloads/
2. Download **JDK 17** for macOS
3. Install it
4. Set JAVA_HOME:
   ```bash
   echo 'export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home' >> ~/.zshrc
   source ~/.zshrc
   ```
5. Verify:
   ```bash
   java -version
   ```

### Step 4: Install Android Studio

1. Visit https://developer.android.com/studio
2. Download and install **Android Studio**
3. Open Android Studio
4. Click **More Actions** → **SDK Manager**
5. In **SDK Platforms** tab, check:
   - ✅ Android 14.0 (API Level 34)
6. In **SDK Tools** tab, check:
   - ✅ Android SDK Build-Tools 34.0.0
   - ✅ Android SDK Command-line Tools
   - ✅ Android SDK Platform-Tools
   - ✅ Android Emulator (optional)
7. Click **Apply** and wait for installation

### Step 5: Set Android Environment Variables

Add these to your `~/.zshrc`:
```bash
echo 'export ANDROID_HOME=$HOME/Library/Android/sdk' >> ~/.zshrc
echo 'export PATH=$PATH:$ANDROID_HOME/emulator' >> ~/.zshrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.zshrc
echo 'export PATH=$PATH:$ANDROID_HOME/tools' >> ~/.zshrc
echo 'export PATH=$PATH:$ANDROID_HOME/tools/bin' >> ~/.zshrc
source ~/.zshrc
```

Verify:
```bash
echo $ANDROID_HOME
# Should show: /Users/shakildodhiya/Library/Android/sdk
```

---

## Project Setup

### Step 6: Install Project Dependencies

```bash
cd /Users/shakildodhiya/Desktop/office/ieditonline_apk
npm install
```

This will install:
- React Native
- React Native WebView
- All other dependencies

**Wait for it to complete** (may take 5-10 minutes)

---

## Building Debug APK

### Step 7: Build Debug APK (For Testing)

This creates an APK you can use for testing:

```bash
cd /Users/shakildodhiya/Desktop/office/ieditonline_apk/android
./gradlew assembleDebug
```

**First build may take 10-15 minutes!** ☕

### Step 8: Locate Your Debug APK

Your APK is ready at:
```
/Users/shakildodhiya/Desktop/office/ieditonline_apk/android/app/build/outputs/apk/debug/app-debug.apk
```

**You can now skip to [Installing APK on Device](#installing-apk-on-device)**

---

## Building Release APK

### Step 9: Generate Signing Key (First Time Only)

For a production-ready APK, you need a signing key:

```bash
cd /Users/shakildodhiya/Desktop/office/ieditonline_apk/android/app
keytool -genkeypair -v -storetype PKCS12 -keystore my-upload-key.keystore -alias my-key-alias -keyalg RSA -keysize 2048 -validity 10000
```

**You'll be asked for:**
- **Keystore password**: Create a strong password (REMEMBER THIS!)
- **Re-enter password**: Same password
- **Key password**: Press Enter to use same password
- **First and last name**: Your name or company name
- **Organizational unit**: Your department (or press Enter)
- **Organization**: Your company (or press Enter)
- **City**: Your city
- **State**: Your state
- **Country code**: Your country (e.g., US, IN)
- **Confirm**: Type `yes`

**⚠️ CRITICAL:** Save these passwords! You'll need them for all future app updates.

### Step 10: Configure Signing Credentials

Create/edit the file `android/gradle.properties` and add these lines at the end:

```properties
MYAPP_UPLOAD_STORE_FILE=my-upload-key.keystore
MYAPP_UPLOAD_KEY_ALIAS=my-key-alias
MYAPP_UPLOAD_STORE_PASSWORD=your_keystore_password_here
MYAPP_UPLOAD_KEY_PASSWORD=your_key_password_here
```

**Replace** `your_keystore_password_here` and `your_key_password_here` with your actual passwords.

### Step 11: Build Release APK

```bash
cd /Users/shakildodhiya/Desktop/office/ieditonline_apk/android
./gradlew assembleRelease
```

### Step 12: Locate Your Release APK

Your production APK is at:
```
/Users/shakildodhiya/Desktop/office/ieditonline_apk/android/app/build/outputs/apk/release/app-release.apk
```

---

## Installing APK on Device

### Method 1: Direct Transfer (Easiest)

1. **Copy APK to your phone:**
   - Connect phone via USB
   - Copy `app-debug.apk` or `app-release.apk` to your phone's Downloads folder

2. **Install on phone:**
   - Open **Files** or **Downloads** app on your phone
   - Tap the APK file
   - If prompted, allow **"Install from Unknown Sources"**
   - Tap **Install**
   - Tap **Open** to launch the app

### Method 2: Using ADB (Advanced)

1. **Enable Developer Options on your phone:**
   - Go to **Settings** → **About Phone**
   - Tap **Build Number** 7 times
   - You'll see "You are now a developer!"

2. **Enable USB Debugging:**
   - Go to **Settings** → **Developer Options**
   - Enable **USB Debugging**

3. **Connect and Install:**
   ```bash
   # Connect phone via USB
   # For debug APK:
   adb install /Users/shakildodhiya/Desktop/office/ieditonline_apk/android/app/build/outputs/apk/debug/app-debug.apk
   
   # For release APK:
   adb install /Users/shakildodhiya/Desktop/office/ieditonline_apk/android/app/build/outputs/apk/release/app-release.apk
   ```

---

## Troubleshooting

### Problem: "npm permission errors"
**Solution:**
```bash
sudo chown -R $(whoami) ~/.npm
```

### Problem: "Gradle build failed"
**Solution:**
```bash
cd /Users/shakildodhiya/Desktop/office/ieditonline_apk/android
./gradlew clean
cd ..
rm -rf android/app/build
./gradlew assembleDebug
```

### Problem: "SDK not found"
**Solution:**
```bash
# Check if ANDROID_HOME is set
echo $ANDROID_HOME

# If empty, add to ~/.zshrc:
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
source ~/.zshrc
```

### Problem: "JAVA_HOME not set"
**Solution:**
```bash
# Find Java installation
/usr/libexec/java_home -V

# Set JAVA_HOME
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home
```

### Problem: "Command not found: gradlew"
**Solution:**
```bash
cd /Users/shakildodhiya/Desktop/office/ieditonline_apk/android
chmod +x gradlew
./gradlew assembleDebug
```

### Problem: "App crashes when opening"
**Solution:**
- Make sure you have internet connection
- Check if https://staging.ieditonline.com is accessible in a browser
- View logs: `adb logcat`

### Problem: "Build takes too long"
**Solution:**
- First build is always slow (10-15 minutes)
- Subsequent builds are faster (2-3 minutes)
- Make sure you have good internet connection

---

## Quick Reference Commands

### Install Dependencies
```bash
npm install
```

### Build Debug APK
```bash
cd android && ./gradlew assembleDebug
```

### Build Release APK
```bash
cd android && ./gradlew assembleRelease
```

### Clean Build
```bash
cd android && ./gradlew clean
```

### Install APK via ADB
```bash
adb install android/app/build/outputs/apk/debug/app-debug.apk
```

### Check Connected Devices
```bash
adb devices
```

### View App Logs
```bash
adb logcat
```

---

## Using the Interactive Build Script

For an easier experience, use the build script:

```bash
cd /Users/shakildodhiya/Desktop/office/ieditonline_apk
./build.sh
```

This shows a menu:
1. Install dependencies
2. Build Debug APK (for testing)
3. Build Release APK (for production)
4. Clean build
5. Run on connected device/emulator
6. Exit

---

## Summary: Fastest Path to APK

**For Testing (5 steps):**
```bash
# 1. Fix npm
sudo chown -R $(whoami) ~/.npm

# 2. Navigate to project
cd /Users/shakildodhiya/Desktop/office/ieditonline_apk

# 3. Install dependencies
npm install

# 4. Build APK
cd android && ./gradlew assembleDebug

# 5. Find APK at:
# android/app/build/outputs/apk/debug/app-debug.apk
```

**For Production (Add these steps):**
```bash
# 6. Generate key
cd app
keytool -genkeypair -v -storetype PKCS12 -keystore my-upload-key.keystore -alias my-key-alias -keyalg RSA -keysize 2048 -validity 10000

# 7. Configure gradle.properties with passwords

# 8. Build release
cd .. && ./gradlew assembleRelease

# 9. Find APK at:
# android/app/build/outputs/apk/release/app-release.apk
```

---

## What You Get

✅ **App Name:** IEdit Online  
✅ **Package:** com.ieditonlineapp  
✅ **URL:** https://staging.ieditonline.com  
✅ **Features:**
- WebView with full website functionality
- Loading indicator
- Back button support
- Error handling
- Offline detection

---

## Next Steps After Building

1. ✅ Test the APK on your device
2. ✅ Customize app name/icon if needed
3. ✅ Build release APK with signing key
4. ✅ Share APK or publish to Google Play Store

---

## Additional Resources

- **Full Documentation:** See `README.md`
- **Quick Start Guide:** See `QUICKSTART.md`
- **Project Summary:** See `PROJECT_SUMMARY.md`
- **Build Workflow:** See `.agent/workflows/build-apk.md`

---

**Created:** November 28, 2025  
**Last Updated:** November 28, 2025  
**Version:** 1.0.0

---

## ✅ Checklist

Before building, make sure:
- [ ] Node.js installed (v18+)
- [ ] Java JDK 17 installed
- [ ] Android Studio installed
- [ ] Android SDK Platform 34 installed
- [ ] Android SDK Build-Tools 34.0.0 installed
- [ ] JAVA_HOME environment variable set
- [ ] ANDROID_HOME environment variable set
- [ ] npm cache permissions fixed
- [ ] Project dependencies installed (`npm install`)

For release build, also:
- [ ] Signing key generated
- [ ] gradle.properties configured with passwords
- [ ] Keystore file backed up safely

---

**Good luck! 🚀**

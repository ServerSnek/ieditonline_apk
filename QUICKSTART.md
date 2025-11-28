# Quick Start Guide - Building Your APK

## 🎯 Simple Steps to Create Your APK

Follow these steps in order to build your Android APK file.

---

## ✅ Step 1: Install Prerequisites

### Install Node.js
1. Go to https://nodejs.org/
2. Download and install the LTS version (v18 or higher)
3. Verify installation:
   ```bash
   node --version
   npm --version
   ```

### Install Java JDK 17
1. Go to https://www.oracle.com/java/technologies/downloads/
2. Download JDK 17 for macOS
3. Install it
4. Add to your `~/.zshrc`:
   ```bash
   export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home
   ```
5. Reload: `source ~/.zshrc`

### Install Android Studio
1. Go to https://developer.android.com/studio
2. Download and install Android Studio
3. Open Android Studio
4. Go to: **Settings → Appearance & Behavior → System Settings → Android SDK**
5. Install:
   - ✅ Android SDK Platform 34
   - ✅ Android SDK Build-Tools 34.0.0
   - ✅ Android SDK Command-line Tools
   - ✅ Android SDK Platform-Tools

### Set Android Environment Variables
Add these to your `~/.zshrc`:
```bash
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
```

Then reload:
```bash
source ~/.zshrc
```

---

## 🔧 Step 2: Fix npm Cache (If Needed)

If you see npm permission errors, run:
```bash
sudo chown -R $(whoami) ~/.npm
```

---

## 📦 Step 3: Install Project Dependencies

Open Terminal and navigate to your project:
```bash
cd /Users/shakildodhiya/Desktop/office/ieditonline_apk
npm install
```

This will install all required packages including React Native and WebView.

---

## 🏗️ Step 4: Build Your APK

You have two options:

### Option A: Debug APK (Quick & Easy - For Testing)

```bash
cd /Users/shakildodhiya/Desktop/office/ieditonline_apk/android
./gradlew assembleDebug
```

**Your APK will be at:**
```
android/app/build/outputs/apk/debug/app-debug.apk
```

### Option B: Release APK (For Production/Distribution)

#### B1. Generate Signing Key (First Time Only)

```bash
cd /Users/shakildodhiya/Desktop/office/ieditonline_apk/android/app
keytool -genkeypair -v -storetype PKCS12 -keystore my-upload-key.keystore -alias my-key-alias -keyalg RSA -keysize 2048 -validity 10000
```

**You'll be asked for:**
- Keystore password (create one and REMEMBER IT!)
- Key password (create one and REMEMBER IT!)
- Your name, organization, city, etc.

**⚠️ IMPORTANT:** Save this keystore file! You'll need it for all future app updates.

#### B2. Configure Signing

Edit `android/gradle.properties` and add these lines at the end:
```properties
MYAPP_UPLOAD_STORE_FILE=my-upload-key.keystore
MYAPP_UPLOAD_KEY_ALIAS=my-key-alias
MYAPP_UPLOAD_STORE_PASSWORD=your_password_here
MYAPP_UPLOAD_KEY_PASSWORD=your_password_here
```

Replace `your_password_here` with the passwords you created.

#### B3. Build Release APK

```bash
cd /Users/shakildodhiya/Desktop/office/ieditonline_apk/android
./gradlew assembleRelease
```

**Your APK will be at:**
```
android/app/build/outputs/apk/release/app-release.apk
```

---

## 📱 Step 5: Install APK on Your Phone

### Method 1: Direct Transfer
1. Connect your phone to your Mac via USB
2. Copy the APK file to your phone
3. On your phone, open the APK file
4. Allow "Install from Unknown Sources" if prompted
5. Tap "Install"

### Method 2: Using ADB
1. Enable Developer Options on your phone:
   - Go to **Settings → About Phone**
   - Tap "Build Number" 7 times
2. Enable USB Debugging:
   - Go to **Settings → Developer Options**
   - Enable "USB Debugging"
3. Connect phone via USB
4. Run:
   ```bash
   adb install /Users/shakildodhiya/Desktop/office/ieditonline_apk/android/app/build/outputs/apk/debug/app-debug.apk
   ```

---

## 🎨 Customization (Optional)

### Change App Name
Edit `android/app/src/main/res/values/strings.xml`:
```xml
<string name="app_name">Your App Name</string>
```

### Change Website URL
Edit `App.tsx` line 47:
```typescript
source={{uri: 'https://your-website.com'}}
```

### Change App Icon
Replace icon files in `android/app/src/main/res/mipmap-*/ic_launcher.png`

You can use online tools like:
- https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html
- https://appicon.co/

---

## 🚀 Using the Build Script (Easy Way)

Instead of typing commands, you can use the interactive build script:

```bash
cd /Users/shakildodhiya/Desktop/office/ieditonline_apk
./build.sh
```

This will show you a menu with options:
1. Install dependencies
2. Build Debug APK
3. Build Release APK
4. Clean build
5. Run on device
6. Exit

---

## 🐛 Troubleshooting

### Problem: "Gradle build failed"
**Solution:**
```bash
cd android
./gradlew clean
cd ..
rm -rf android/app/build
npm install
```

### Problem: "SDK not found"
**Solution:**
- Make sure Android Studio is installed
- Verify ANDROID_HOME is set: `echo $ANDROID_HOME`
- Should show: `/Users/shakildodhiya/Library/Android/sdk`

### Problem: "npm permission errors"
**Solution:**
```bash
sudo chown -R $(whoami) ~/.npm
```

### Problem: "App crashes when opening"
**Solution:**
- Check internet connection
- Make sure the URL is accessible in a browser
- Check logs: `adb logcat`

### Problem: "Command not found: gradlew"
**Solution:**
```bash
cd android
chmod +x gradlew
./gradlew assembleDebug
```

---

## 📋 Summary Checklist

- [ ] Node.js installed
- [ ] Java JDK 17 installed
- [ ] Android Studio installed
- [ ] Android SDK installed
- [ ] Environment variables set
- [ ] npm cache fixed (if needed)
- [ ] Dependencies installed (`npm install`)
- [ ] APK built successfully
- [ ] APK installed on phone
- [ ] App opens and shows website

---

## 🎉 Success!

If you've followed all steps, you should now have:
- ✅ A working React Native app
- ✅ An APK file ready to install
- ✅ The app showing https://staging.ieditonline.com

---

## 📞 Need Help?

Common resources:
- React Native Docs: https://reactnative.dev/
- Android Developer Docs: https://developer.android.com/
- Stack Overflow: https://stackoverflow.com/questions/tagged/react-native

---

**Last Updated:** November 28, 2025

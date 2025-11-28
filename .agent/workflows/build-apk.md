---
description: Build Android APK for IEdit Online app
---

# Build Android APK Workflow

This workflow guides you through building an Android APK from the React Native project.

## Prerequisites Check

1. Verify Node.js is installed:
```bash
node --version
```
Should show v18 or higher.

2. Verify Java is installed:
```bash
java -version
```
Should show version 17 or higher.

3. Verify Android SDK is configured:
```bash
echo $ANDROID_HOME
```
Should show path to Android SDK.

## Build Steps

### For Debug APK (Testing)

// turbo
1. Install dependencies:
```bash
npm install
```

// turbo
2. Build debug APK:
```bash
cd android && ./gradlew assembleDebug && cd ..
```

3. Find your APK at:
```
android/app/build/outputs/apk/debug/app-debug.apk
```

### For Release APK (Production)

1. Generate signing key (first time only):
```bash
cd android/app && keytool -genkeypair -v -storetype PKCS12 -keystore my-upload-key.keystore -alias my-key-alias -keyalg RSA -keysize 2048 -validity 10000 && cd ../..
```

2. Configure gradle.properties with signing credentials

3. Build release APK:
```bash
cd android && ./gradlew assembleRelease && cd ..
```

4. Find your APK at:
```
android/app/build/outputs/apk/release/app-release.apk
```

## Installation

Install on connected device:
```bash
adb install android/app/build/outputs/apk/debug/app-debug.apk
```

## Troubleshooting

If build fails, clean and retry:
```bash
cd android && ./gradlew clean && cd ..
rm -rf node_modules
npm install
```

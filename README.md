# IEdit Online React Native App - Build Guide

## Project Overview
This is a React Native application that displays the IEdit Online website (https://staging.ieditonline.com) in a WebView.

## Prerequisites

Before you can build the APK, you need to install the following:

### 1. Node.js and npm
- Download and install Node.js (v18 or higher) from https://nodejs.org/
- Verify installation:
  ```bash
  node --version
  npm --version
  ```

### 2. Java Development Kit (JDK)
- Install JDK 17 (recommended for React Native 0.73)
- Download from: https://www.oracle.com/java/technologies/downloads/
- Set JAVA_HOME environment variable:
  ```bash
  export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home
  ```

### 3. Android Studio
- Download from: https://developer.android.com/studio
- During installation, make sure to install:
  - Android SDK
  - Android SDK Platform
  - Android Virtual Device (optional, for testing)
  
### 4. Android SDK Setup
- Open Android Studio > Settings > Appearance & Behavior > System Settings > Android SDK
- Install the following:
  - Android SDK Platform 34
  - Android SDK Build-Tools 34.0.0
  - Android SDK Command-line Tools
  - Android SDK Platform-Tools
  - Android Emulator (optional)

### 5. Set Environment Variables
Add these to your `~/.zshrc` or `~/.bash_profile`:

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

## Installation Steps

### Step 1: Fix npm Cache Issue (if needed)
If you encounter npm cache permission errors, run:
```bash
sudo chown -R $(whoami) ~/.npm
```

### Step 2: Install Dependencies
Navigate to the project directory and install dependencies:
```bash
cd /Users/shakildodhiya/Desktop/office/ieditonline_apk
npm install
```

### Step 3: Install CocoaPods (for iOS, optional)
```bash
sudo gem install cocoapods
cd ios && pod install && cd ..
```

## Building the APK

### Method 1: Debug APK (Quick Build)

This creates an APK for testing purposes:

```bash
cd android
./gradlew assembleDebug
```

The APK will be located at:
```
android/app/build/outputs/apk/debug/app-debug.apk
```

### Method 2: Release APK (Production Build)

#### Step 2.1: Generate a Signing Key

First, create a keystore file for signing your app:

```bash
cd android/app
keytool -genkeypair -v -storetype PKCS12 -keystore my-upload-key.keystore -alias my-key-alias -keyalg RSA -keysize 2048 -validity 10000
```

You'll be prompted to enter:
- Keystore password (remember this!)
- Key password (remember this!)
- Your name, organization, etc.

**IMPORTANT**: Keep this keystore file safe! You'll need it for all future updates.

#### Step 2.2: Configure Gradle Variables

Create a file `android/gradle.properties` (if not exists) and add:

```properties
MYAPP_UPLOAD_STORE_FILE=my-upload-key.keystore
MYAPP_UPLOAD_KEY_ALIAS=my-key-alias
MYAPP_UPLOAD_STORE_PASSWORD=your_keystore_password
MYAPP_UPLOAD_KEY_PASSWORD=your_key_password
```

**IMPORTANT**: Never commit this file to version control! Add it to `.gitignore`.

#### Step 2.3: Build Release APK

```bash
cd android
./gradlew assembleRelease
```

The release APK will be located at:
```
android/app/build/outputs/apk/release/app-release.apk
```

### Method 3: Android App Bundle (AAB) for Google Play

For publishing to Google Play Store, use AAB format:

```bash
cd android
./gradlew bundleRelease
```

The AAB will be located at:
```
android/app/build/outputs/bundle/release/app-release.aab
```

## Testing the App

### Test on Physical Device

1. Enable Developer Options on your Android device:
   - Go to Settings > About Phone
   - Tap "Build Number" 7 times
   
2. Enable USB Debugging:
   - Go to Settings > Developer Options
   - Enable "USB Debugging"

3. Connect your device via USB

4. Run the app:
   ```bash
   npm run android
   ```

### Test on Emulator

1. Open Android Studio
2. Go to Tools > Device Manager
3. Create a new Virtual Device
4. Start the emulator
5. Run:
   ```bash
   npm run android
   ```

## Installing the APK

### On Your Device

1. Transfer the APK to your device
2. Open the APK file
3. Allow installation from unknown sources if prompted
4. Install the app

### Using ADB

```bash
adb install android/app/build/outputs/apk/release/app-release.apk
```

## Customization

### Change App Name
Edit `android/app/src/main/res/values/strings.xml`:
```xml
<string name="app_name">Your App Name</string>
```

### Change App Icon
Replace the following files in `android/app/src/main/res/`:
- `mipmap-hdpi/ic_launcher.png` (72x72)
- `mipmap-mdpi/ic_launcher.png` (48x48)
- `mipmap-xhdpi/ic_launcher.png` (96x96)
- `mipmap-xxhdpi/ic_launcher.png` (144x144)
- `mipmap-xxxhdpi/ic_launcher.png` (192x192)

### Change Package Name
1. Edit `android/app/build.gradle`:
   ```gradle
   defaultConfig {
       applicationId "com.yourcompany.yourapp"
   }
   ```

2. Rename the Java package directories and update imports

### Change WebView URL
Edit `App.tsx`:
```typescript
<WebView
  source={{uri: 'https://your-url.com'}}
  // ... other props
/>
```

## Troubleshooting

### Common Issues

1. **Gradle build fails**
   - Clean the build: `cd android && ./gradlew clean`
   - Delete `android/app/build` folder
   - Try again

2. **Metro bundler issues**
   - Clear cache: `npm start -- --reset-cache`
   - Delete `node_modules` and reinstall: `rm -rf node_modules && npm install`

3. **SDK not found**
   - Verify ANDROID_HOME is set correctly
   - Check SDK is installed in Android Studio

4. **App crashes on launch**
   - Check logs: `adb logcat`
   - Verify all dependencies are installed

5. **WebView not loading**
   - Check internet connection
   - Verify URL is accessible
   - Check AndroidManifest.xml has INTERNET permission

## App Features

- ✅ Full WebView of staging.ieditonline.com
- ✅ Hardware back button support
- ✅ Loading indicator
- ✅ Error handling
- ✅ JavaScript enabled
- ✅ Local storage support
- ✅ Gesture navigation support

## File Structure

```
ieditonline_apk/
├── android/                 # Android native code
│   ├── app/
│   │   ├── build.gradle    # App-level build configuration
│   │   └── src/main/
│   │       ├── AndroidManifest.xml
│   │       ├── java/com/ieditonlineapp/
│   │       │   ├── MainActivity.java
│   │       │   └── MainApplication.java
│   │       └── res/        # Resources (icons, strings, etc.)
│   ├── build.gradle        # Project-level build configuration
│   └── gradle.properties   # Gradle properties
├── App.tsx                 # Main app component
├── index.js               # Entry point
├── package.json           # Dependencies
└── README.md             # This file
```

## Next Steps

1. Install dependencies: `npm install`
2. Build debug APK: `cd android && ./gradlew assembleDebug`
3. Test on device or emulator
4. Generate signing key for release
5. Build release APK
6. Install and test
7. Publish to Google Play Store (optional)

## Support

For issues or questions:
- React Native docs: https://reactnative.dev/
- React Native WebView: https://github.com/react-native-webview/react-native-webview

---

**Created**: November 28, 2025
**Version**: 1.0.0

#!/bin/bash

# IEdit Online App - Quick Build Script
# This script helps you build the Android APK

set -e

echo "🚀 IEdit Online App - Build Script"
echo "===================================="
echo ""

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found. Please run this script from the project root."
    exit 1
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo "📋 Checking prerequisites..."
echo ""

if ! command_exists node; then
    echo "❌ Node.js is not installed. Please install Node.js from https://nodejs.org/"
    exit 1
else
    echo "✅ Node.js: $(node --version)"
fi

if ! command_exists npm; then
    echo "❌ npm is not installed."
    exit 1
else
    echo "✅ npm: $(npm --version)"
fi

if ! command_exists java; then
    echo "❌ Java is not installed. Please install JDK 17."
    exit 1
else
    echo "✅ Java: $(java -version 2>&1 | head -n 1)"
fi

if [ -z "$ANDROID_HOME" ]; then
    echo "⚠️  Warning: ANDROID_HOME is not set. Android SDK may not be found."
else
    echo "✅ ANDROID_HOME: $ANDROID_HOME"
fi

echo ""
echo "===================================="
echo "What would you like to do?"
echo "===================================="
echo "1) Install dependencies"
echo "2) Build Debug APK (for testing)"
echo "3) Build Release APK (for production)"
echo "4) Clean build"
echo "5) Run on connected device/emulator"
echo "6) Exit"
echo ""
read -p "Enter your choice (1-6): " choice

case $choice in
    1)
        echo ""
        echo "📦 Installing dependencies..."
        npm install
        echo "✅ Dependencies installed successfully!"
        ;;
    2)
        echo ""
        echo "🔨 Building Debug APK..."
        cd android
        ./gradlew assembleDebug
        cd ..
        echo ""
        echo "✅ Debug APK built successfully!"
        echo "📍 Location: android/app/build/outputs/apk/debug/app-debug.apk"
        ;;
    3)
        echo ""
        echo "🔨 Building Release APK..."
        echo ""
        echo "⚠️  Make sure you have:"
        echo "   1. Generated a signing key"
        echo "   2. Configured gradle.properties with signing credentials"
        echo ""
        read -p "Continue? (y/n): " confirm
        if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
            cd android
            ./gradlew assembleRelease
            cd ..
            echo ""
            echo "✅ Release APK built successfully!"
            echo "📍 Location: android/app/build/outputs/apk/release/app-release.apk"
        else
            echo "Build cancelled."
        fi
        ;;
    4)
        echo ""
        echo "🧹 Cleaning build..."
        cd android
        ./gradlew clean
        cd ..
        rm -rf node_modules
        echo "✅ Build cleaned successfully!"
        echo "Run option 1 to reinstall dependencies."
        ;;
    5)
        echo ""
        echo "🚀 Running app on device/emulator..."
        npm run android
        ;;
    6)
        echo "Goodbye! 👋"
        exit 0
        ;;
    *)
        echo "❌ Invalid choice. Please run the script again."
        exit 1
        ;;
esac

echo ""
echo "===================================="
echo "✨ Done!"
echo "===================================="

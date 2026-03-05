#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

APP="GongfuTimer.app"

echo "Building release..."
swift build -c release

echo "Assembling $APP..."
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp .build/release/GongfuTimer "$APP/Contents/MacOS/"

# Resolve Info.plist (replace XcodeGen variables with actual values)
cat > "$APP/Contents/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>en</string>
	<key>CFBundleExecutable</key>
	<string>GongfuTimer</string>
	<key>CFBundleIconFile</key>
	<string>AppIcon</string>
	<key>CFBundleIdentifier</key>
	<string>com.danielfialkov.gongfu-timer</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>Gongfu Timer</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>1.0</string>
	<key>CFBundleVersion</key>
	<string>1</string>
	<key>LSUIElement</key>
	<true/>
</dict>
</plist>
EOF

# Generate icon if needed
if [ ! -f "$APP/Contents/Resources/AppIcon.icns" ]; then
    echo "Generating icon..."
    swift scripts/generate_icon.swift
    iconutil -c icns /tmp/GongfuTimer.iconset -o "$APP/Contents/Resources/AppIcon.icns"
fi

# Touch to bust Finder icon cache
touch "$APP"

echo "Done: $APP ($(du -sh "$APP" | cut -f1))"

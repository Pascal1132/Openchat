#!/bin/bash
# Deploy OpenChat web build to the live server directory.

set -euo pipefail

WEB_SOURCE="/root/test-html-site/chat/build/web"
APK_SOURCE="/root/test-html-site/chat/build/app/outputs/flutter-apk/app-release.apk"
TARGET_DIR="/srv/test.pascalparent.ca/html/chat"
APK_TARGET="$TARGET_DIR/openchat.apk"

echo "Building OpenChat for web..."
cd /root/test-html-site/chat
export PATH="$PATH:/root/flutter/bin"
# pwa-strategy=none: do not generate/register a service worker (it caches the
# app too aggressively behind Cloudflare and traps users on stale builds).
flutter build web --release --base-href /chat/ --pwa-strategy=none

echo "Deploying to $TARGET_DIR..."
if [ -L "$TARGET_DIR" ]; then
  rm -f "$TARGET_DIR"
elif [ -d "$TARGET_DIR" ]; then
  rm -rf "$TARGET_DIR"
fi

cp -r "$WEB_SOURCE" "$TARGET_DIR"

# Cache-bust the entrypoint scripts so Cloudflare (which caches fixed-name
# .js for 4h) is forced to fetch the new build. index.html itself is served
# uncached, so a fresh ?v= ripples through to the rest.
BUILD_ID="$(date +%s)"
sed -i "s#flutter_bootstrap\.js#flutter_bootstrap.js?v=${BUILD_ID}#g" "$TARGET_DIR/index.html"
sed -i "s#main\.dart\.js#main.dart.js?v=${BUILD_ID}#g" "$TARGET_DIR/flutter_bootstrap.js"
echo "Cache-bust build id: ${BUILD_ID}"

find "$TARGET_DIR" -type d -exec chmod 755 {} \;
find "$TARGET_DIR" -type f -exec chmod 644 {} \;

if [ -f "$APK_SOURCE" ]; then
  echo "Deploying APK..."
  cp "$APK_SOURCE" "$APK_TARGET"
  chmod 644 "$APK_TARGET"
else
  echo "No APK found at $APK_SOURCE; skipped."
  echo "Run 'flutter build apk --release' to produce it."
fi

echo "Deployment complete."
echo "Verify: https://test.pascalparent.ca/chat/"
echo "APK (if built): https://test.pascalparent.ca/chat/openchat.apk"

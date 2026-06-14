#!/bin/bash
# Deploy OpenChat web build to the live server directory.

set -euo pipefail

SOURCE="/root/test-html-site/chat/build/web"
TARGET="/srv/test.pascalparent.ca/html/chat"

echo "Building OpenChat for web..."
cd /root/test-html-site/chat
export PATH="$PATH:/root/flutter/bin"
flutter build web --release --base-href /chat/

echo "Deploying to $TARGET..."
if [ -L "$TARGET" ]; then
  rm -f "$TARGET"
elif [ -d "$TARGET" ]; then
  rm -rf "$TARGET"
fi

cp -r "$SOURCE" "$TARGET"
find "$TARGET" -type d -exec chmod 755 {} \;
find "$TARGET" -type f -exec chmod 644 {} \;

echo "Deployment complete."
echo "Verify: https://test.pascalparent.ca/chat/"

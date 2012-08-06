#!/bin/sh
PROJECT_DIR="infografika"
PLIST_NAME="Infografika-Info.plist"
cd $PROJECT_DIR
version=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$PLIST_NAME")
build=$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "$PLIST_NAME")
filename=$PROJECT_DIR$version"_"$build"_"`eval date +%Y%m%d%H%M`
cd ../
cp -r $PROJECT_DIR/ $filename
rm -rf $filename/.git
zip -m -r -y $filename.zip $filename/
echo "job's done!"

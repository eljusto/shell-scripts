#!/bin/sh
#usage:
# put to directory with main .xcodeproj file and run ./xcodedeploy.sh "Note for build"

projectname='HelloWorld'
PROJECT_DIR="HELLOWORLD" 
PLIST_NAME="$projectname-Info.plist"
hockeyapp_token='' #create here https://rink.hockeyapp.net/manage/auth_tokens
hockeyapp_projectid='' #your public app identifier
project_link='https://rink.hockeyapp.net/api/2/apps/'$hockeyapp_projectid'/app_versions'
NOTES=$1

cd $PROJECT_DIR
version=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$PLIST_NAME")
build=$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "$PLIST_NAME")
let build++
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $build" "$PLIST_NAME"
echo "Project version: $version $build"
echo "Ready to build..."

cd ../
mkdir tmpbuild
./xcodearchive.rb -o $PWD'/tmpbuild'
cd tmpbuild
echo "Project is built. Going to upload..."

curl \
  -F "status=2" \
  -F "notify=1" \
  -F "notes=$NOTES" \
  -F "notes_type=0" \
  -F "ipa=@$projectname.ipa" \
  -F "dsym=@$projectname.dSYM.zip" \
  -H "X-HockeyAppToken: $hockeyapp_token" \
$project_link
cd ../
rm -rf tmpbuild

echo "Job's done!"

############################
# Parameters
# ipa - optional (required, if dsym is not specified for iOS or Mac), file data of the .ipa or .apk file
# dsym - optional, file data of the .dSYM.zip file (iOS and Mac) or mapping.txt (Android)
# notes - optional, release notes as Textile or Markdown
# notes_type - optional, type of release notes:
#  0 - Textile
#  1 - Markdown
# notify - optional, notify testers (can only be set with full-access tokens):
#  0 - Don't notify testers
#  1 - Notify all testers that can install this app
# status - optional, download status (can only be set with full-access tokens):
#  1: Don't allow users to download or install the version
#  2: Available for download or installation
# mandatory - optional, set version as mandatory:
#  0 - no
#  1 - yes
# tags - optional, restrict download to comma-separated list of tags; iOS-only

#!/bin/sh
projectname='Projectname'
username='username@mail.com' #Basecamp login
password='' #Basecamp password
project_id='000000-explore-basecamp' #taken from the link to the project in Basecamp
company_id='000000' #taken from the link in Basecamp

PROJECT_DIR="projectname" 
PLIST_NAME="project-Info.plist"

#go to project's dir, copy and remove .git subdirectory from the copied directory
cd $PROJECT_DIR
version=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$PLIST_NAME")
build=$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "$PLIST_NAME")
filename=$PROJECT_DIR$version"_"$build"_"`eval date +%Y%m%d%H%M`
cd ../
cp -r $PROJECT_DIR/ $filename
rm -rf $filename/.git

#move the copied directory to zip-file
zip -m -r -y $filename.zip $filename/

#upload zip-file to the basecamp and get the token from Basecamp's API
token=`curl --data-binary @$filename \
       -u $username:$password \
       -H 'Content-Type: application/octet-stream' \
       -H 'User-Agent: CompressAndSendSource ('$username')' \
       https://basecamp.com/$company_id/api/v1/attachments.json | sed -e 's/[{}]/''/g'`

bash: line 1: Attackment: command not found

#Add the uploaded file to the project's uploads
curl  -H 'Content-Type: application/json' \
    -H 'User-Agent: CompressAndSendSource ('$username')' \
    -u $username:$password \
    -d '{ "content": "Here is a build '$version'_'$build' of '$projectname' app!", "attachments": [ {'$token', "name": "'$filename'" }] }' \
    https://basecamp.com/$company_id/api/v1/projects/$project_id/uploads.json

echo "Job's done!"

echo "Ok lets go- pakaging up $1"

#set plist version
xcrun agvtool new-marketing-version $1

#incrememnt build number
xcrun agvtool next-version -all

#install pods
pod install

sh build-framework.sh ./build-output

sh bintray-upload.sh $1

#remove framework artifact
rm -R build-output
echo "You're welcome :)"

git add .
git commit -m "Build $1"

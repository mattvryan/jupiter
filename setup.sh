## AWS ##
echo 'Setting up AWS libraries...'

# AWS iOS SDK
echo ' └─> Setting up AWS iOS SDK...'
mkdir -p libs/3rdparty/aws/ios
pushd libs/3rdparty/aws/ios
curl -O http://sdk-for-ios.amazonwebservices.com/latest/aws-ios-sdk.zip
unzip aws-ios-sdk.zip
rm aws-ios-sdk.zip
popd


echo 'Done.'

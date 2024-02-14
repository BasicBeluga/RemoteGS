#!/bin/bash


SOURCE=https://github.com/JGRennison/OpenTTD-patches
BRANCH=jgrpp-0.57.1

PACKAGE_NAME="RemoteGS"
PACKAGE_DESCRIPTION="This GS gives admin port clients access to the GS API."
PACKAGE_URL="https://github.com/BasicBeluga/RemoteGS"
PACKAGE_LICENSE="GPL v2"
PACKAGE_VERSION="jgrpp-0.57.1-2"
BANANAS_TOKEN=$(<token)

TAR_NAME=remotegs-$BRANCH.tar
BUILD_IMG_TAG=remotegs-ottd
BUILD_CONTAINER_NAME=rgs-ottd

echo "Building build image..."
docker build -t $BUILD_IMG_TAG --build-arg SOURCE=$SOURCE --build-arg BRANCH=$BRANCH .

echo "Removing old build container..."
docker container rm $BUILD_CONTAINER_NAME

echo "Creating new build container..."
docker create --name $BUILD_CONTAINER_NAME $BUILD_IMG_TAG

echo "Copying updated symbols..."
docker container cp $BUILD_CONTAINER_NAME:/openttd/build/game/RemoteGS/symbols.nut symbols.nut

# Building Bananas-Frontend-Container
echo "Building bananas-frontend-cli container..."
docker build -t bananas --file bananas-frontend-cli.Dockerfile .

# Making Gamescript Tar
echo "Creating RemoteGS tarfile..."
tar -cf $TAR_NAME $( find -name "*.nut" -or -name "*.txt" )

echo "Uploading  "
docker run \
  -v $(pwd)/token:/root/.config/bananas-cli/token \
  -v $(pwd)/$TAR_NAME:/bananas-frontend-cli/$TAR_NAME \
  -e BANANAS_CLI_API_URL="https://bananas-api.openttd.org" \
  bananas \
  .env/bin/python -m bananas_cli upload \
  --version "$PACKAGE_VERSION" \
  --name "$PACKAGE_NAME" \
  --description "$PACKAGE_DESCRIPTION" \
  --url "$PACKAGE_URL" \
  --license "$PACKAGE_LICENSE" \
  $TAR_NAME

curl --header 'Authorization: Bearer '$BANANAS_TOKEN --url https://bananas-api.openttd.org/package/self > my_packages.json
GS_ID=$(cat my_packages.json | jq -r '.[] | select(.name=="RemoteGS") | ."unique-id"')

curl https://bananas-api.openttd.org/package/game-script/$GS_ID > package_info.json
LATEST_DATE=$(cat package_info.json | jq -r .versions[-1].\"upload-date\")


curl --request PUT \
  --url 'https://bananas-api.openttd.org/package/game-script/'$GS_ID'/'$LATEST_DATE \
  --header 'Authorization: Bearer '$BANANAS_TOKEN \
  --header 'Content-Type: application/json' \
  --data '{
	"dependencies": [
		{
			"content-type": "game-script-library",
			"unique-id": "5350524c",
			"md5sum-partial": "4b28bb33"
		}
	],
	"compatibility": [
		{
			"name": "jgrpp",
			"conditions": [
				">= 0.57.1",
				"< 0.57.2"
			]
		}
	]
}'

echo "Done!"




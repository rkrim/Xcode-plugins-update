#! /bin/bash 

XCODE_MAS_URL="https://itunes.apple.com/fr/app/xcode/id497799835"



# Search for Xcode
OPEN_CMD_PATH=`which open`
XCODE_SELECT=`which xcode-select`

if [ -n "$XCODE_SELECT" ]; then
	XCODE_DEV_DIR=`$XCODE_SELECT -p`
fi



# Exit if XCode or its command line tools are not installed
if [[ -z "$XCODE_SELECT" ||  -z "$XCODE_DEV_DIR" ]]; then
    echo "Xcode Command line Tools not found"

    if [ -n "$OPEN_CMD_PATH" ]; then
    	echo "Your default browser should open with Xcode download page"
    	$OPEN_CMD_PATH $XCODE_MAS_URL
	fi

    echo "Exiting..."
    exit
fi



# Substring to .app location
DEV_DIR_RELATIVE_TO_XCODE=${XCODE_DEV_DIR#*.app}
XCODE_APP_PATH=${XCODE_DEV_DIR:0:${#XCODE_DEV_DIR}-${#DEV_DIR_RELATIVE_TO_XCODE}}

if [ -z "$XCODE_APP_PATH" ]; then
    echo "unnable to find the Xcode.app location, Exiting..."
    exit
fi
echo "Found Xcode at $XCODE_APP_PATH"



# Getting Xcode UUID
XCODE_INFO_RELATIVE_PATH="Contents/Info"
XCODE_UUID_KEY="DVTPlugInCompatibilityUUID"
XCODE_UUID=`defaults read $XCODE_APP_PATH/$XCODE_INFO_RELATIVE_PATH $XCODE_UUID_KEY`

if [ -z "$XCODE_UUID" ]; then
    echo "Unnable to find the Xcode UUID, Exiting..."
    exit
fi
echo "With UUID: "$XCODE_UUID



# Updating Plugins Info file
XCODE_USER_PLUGINS_DIR=~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins
XCODE_PLUGIN_COMPATIBILITY_ARRAY="DVTPlugInCompatibilityUUIDs"

for PLUGIN_INFO in "$XCODE_USER_PLUGINS_DIR"/*
do
	printf "Updating: "${PLUGIN_INFO#$XCODE_USER_PLUGINS_DIR/}
	PLUGIN_XCODE_UUID=`defaults read "$PLUGIN_INFO/Contents/Info" $XCODE_PLUGIN_COMPATIBILITY_ARRAY | grep $XCODE_UUID`

	if [ -z "$PLUGIN_XCODE_UUID" ]; then
	 	defaults write "$PLUGIN_INFO/Contents/Info" $XCODE_PLUGIN_COMPATIBILITY_ARRAY -array-add $XCODE_UUID;
	 	echo "\t\t[OK]"
	else
		echo "\t\t[UP TO DATE]"
	fi

done


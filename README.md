# Xcode-plugins-update
Shell script that adds current Xcode UUID to plugins


Every new release of Xcode is tagged with a new DVTPlugInCompatibilityUUID.
And every Xcode plugin has its DVTPlugInCompatibilityUUIDs table, indicating that the plugin is only available with Xcode version that matches UUIDs of the table.
So every time Apple releases a new version of Xcode, plugins are disabled because they do not match, and we need to wait for plugin authors to make sure its compatible and update their plugin Compatibility table.

If you want make them work again without waiting for the author to update, dive a try to this script.


## Requirements

The script needs a copy of Xcode installed from the Mac AppStore (MAS)


## Usage

Make sure the script is executable. If not you can run the following command to make it executable (you need to be in the same folder).
``` bash
chmod +x xcode_plugins_update.sh
```

then you just run the script
``` bash
./xcode_plugins_update.sh
```

#!/bin/sh

parameters="${1}${2}${3}${4}${5}${6}${7}${8}${9}"

Escape_Variables()
{
	volume_version="$(sw_vers -productVersion)"
	volume_version="${volume_version//./}"

	if [[ "$volume_version" -gt "1070" ]]; then
		text_progress="\033[38;5;113m"
		text_success="\033[38;5;113m"
		text_warning="\033[38;5;221m"
		text_error="\033[38;5;203m"
		text_message="\033[38;5;75m"
	else
		text_progress="\033[32;1m"
		text_success="\033[32;1m"
		text_warning="\033[33;1m"
		text_error="\033[31;1m"
		text_message="\033[34;1m"
	fi

	text_bold="\033[1m"
	text_faint="\033[2m"
	text_italic="\033[3m"
	text_underline="\033[4m"

	erase_style="\033[0m"
	erase_line="\033[0K"

	move_up="\033[1A"
	move_down="\033[1B"
	move_foward="\033[1C"
	move_backward="\033[1D"
}

Parameter_Variables()
{
	if [[ $parameters == *"-v"* || $parameters == *"-verbose"* ]]; then
		verbose="1"
		set -x
	fi
}

Path_Variables()
{
	script_path="${0}"
	directory_path="${0%/*}"

	resources_path="$directory_path/resources"

	system_version_path="System/Library/CoreServices/SystemVersion.plist"

	volume_name=""
	volume_path=""
}

Input_Off()
{
	stty -echo
}
Input_On()
{
	stty echo
}

Output_Off() {
	if [[ $verbose == "1" ]]; then
		"$@"
	else
		"$@" &>/dev/null
	fi
}

Check_Environment()
{
	echo ${text_progress}"> Checking system environment."${erase_style}
	if [ -d /Install\ *.app ]; then
		environment="installer"
	fi
	if [ ! -d /Install\ *.app ]; then
		environment="system"
	fi
	echo ${move_up}${erase_line}${text_success}"+ Checked system environment."${erase_style}
}

Check_Root()
{
	echo ${text_progress}"> Checking for root permissions."${erase_style}
	if [[ $environment == "installer" ]]; then
		root_check="passed"
		echo ${move_up}${erase_line}${text_success}"+ Root permissions check passed."${erase_style}
	else
		if [[ $(whoami) == "root" && $environment == "system" ]]; then
			root_check="passed"
			echo ${move_up}${erase_line}${text_success}"+ Root permissions check passed."${erase_style}
		fi
		if [[ ! $(whoami) == "root" && $environment == "system" ]]; then
			root_check="failed"
			echo ${text_error}"- Root permissions check failed."${erase_style}
			echo ${text_message}"/ Run this tool with root permissions."${erase_style}
			Input_On
			exit
		fi
	fi
}

Check_Resources()
{
	echo ${text_progress}"> Checking for resources."${erase_style}
	if [[ -d "$resources_path" ]]; then
		resources_check="passed"
		echo ${move_up}${erase_line}${text_success}"+ Resources check passed."${erase_style}
	fi
	if [[ ! -d "$resources_path" ]]; then
		resources_check="failed"
		echo ${text_error}"- Resources check failed."${erase_style}
		echo ${text_message}"/ Run this tool with the required resources."${erase_style}
		Input_On
		exit
	fi
}

Check_Volume_Version()
{
	echo ${text_progress}"> Checking system version."${erase_style}	
	volume_version="$(grep -A1 "ProductVersion" "$volume_path/$system_version_path")"

	volume_version="${volume_version#*<string>}"
	volume_version="${volume_version%</string>*}"

	volume_version_short="${volume_version:0:4}"
	echo ${move_up}${erase_line}${text_success}"+ Checked system version."${erase_style}

	echo ${text_progress}"> Checking system support."${erase_style}
	if [[ $volume_version_short == "10.5" ]]; then
		echo ${move_up}${erase_line}${text_success}"+ System support check passed."${erase_style}
	fi
	if [[ ! $volume_version_short == "10.5" ]]; then
		echo ${text_error}"- System support check failed."${erase_style}
		echo ${text_message}"/ Run this tool on a supported system."${erase_style}
		Input_On
		exit
	fi
}

Patch_Volume()
{
	echo ${text_progress}"> Patching app icons."${erase_style}
	cp -R "$resources_path"/Applications/Address\ Book/ "$volume_path"/Applications/Address\ Book.app/Contents/Resources
	cp -R "$resources_path"/Applications/Automator/ "$volume_path"/Applications/Automator.app/Contents/Resources
	cp -R "$resources_path"/Applications/Calculator/ "$volume_path"/Applications/Calculator.app/Contents/Resources
	cp -R "$resources_path"/Applications/Chess/ "$volume_path"/Applications/Chess.app/Contents/Resources
	cp -R "$resources_path"/Applications/DVD\ Player/ "$volume_path"/Applications/DVD\ Player.app/Contents/Resources
	cp -R "$resources_path"/Applications/Dashboard/ "$volume_path"/Applications/Dashboard.app/Contents/Resources
	cp -R "$resources_path"/Applications/Dictionary/ "$volume_path"/Applications/Dictionary.app/Contents/Resources
	cp -R "$resources_path"/Applications/Expose/ "$volume_path"/Applications/Expose.app/Contents/Resources
	cp -R "$resources_path"/Applications/Font\ Book/ "$volume_path"/Applications/Font\ Book.app/Contents/Resources
	cp -R "$resources_path"/Applications/Image\ Capture/ "$volume_path"/Applications/Image\ Capture.app/Contents/Resources
	cp -R "$resources_path"/Applications/Mail/ "$volume_path"/Applications/Mail.app/Contents/Resources
	cp -R "$resources_path"/Applications/Photo\ Booth/ "$volume_path"/Applications/Photo\ Booth.app/Contents/Resources
	cp -R "$resources_path"/Applications/Preview/ "$volume_path"/Applications/Preview.app/Contents/Resources
	cp -R "$resources_path"/Applications/QuickTime\ Player/ "$volume_path"/Applications/QuickTime\ Player.app/Contents/Resources
	cp -R "$resources_path"/Applications/Safari/ "$volume_path"/Applications/Safari.app/Contents/Resources
	cp -R "$resources_path"/Applications/Spaces/ "$volume_path"/Applications/Spaces.app/Contents/Resources
	cp -R "$resources_path"/Applications/Stickies/ "$volume_path"/Applications/Stickies.app/Contents/Resources
	cp -R "$resources_path"/Applications/System\ Preferences/ "$volume_path"/Applications/System\ Preferences.app/Contents/Resources
	cp -R "$resources_path"/Applications/TextEdit/ "$volume_path"/Applications/TextEdit.app/Contents/Resources
	cp -R "$resources_path"/Applications/Time\ Machine/ "$volume_path"/Applications/Time\ Machine.app/Contents/Resources
	cp -R "$resources_path"/Applications/iCal/ "$volume_path"/Applications/iCal.app/Contents/Resources
	cp -R "$resources_path"/Applications/iCal/ "$volume_path"/Applications/iCal.app/Contents/Resources/iCalDockExtra.bundle/Contents/Resources
	cp -R "$resources_path"/Applications/iChat/ "$volume_path"/Applications/iChat.app/Contents/Resources
	cp -R "$resources_path"/Applications/iTunes/ "$volume_path"/Applications/iTunes.app/Contents/Resources
	echo ${move_up}${erase_line}${text_success}"+ Patched app icons."${erase_style}

	echo ${text_progress}"> Patching utility app icons."${erase_style}
	cp -R "$resources_path"/Applications/Utilities/Activity\ Monitor/ "$volume_path"/Applications/Utilities/Activity\ Monitor.app/Contents/Resources
	cp -R "$resources_path"/Applications/Utilities/AirPort\ Utility/ "$volume_path"/Applications/Utilities/AirPort\ Utility.app/Contents/Resources
	cp -R "$resources_path"/Applications/Utilities/Audio\ MIDI\ Setup/ "$volume_path"/Applications/Utilities/Audio\ MIDI\ Setup.app/Contents/Resources
	cp -R "$resources_path"/Applications/Utilities/Bluetooth\ File\ Exchange/ "$volume_path"/Applications/Utilities/Bluetooth\ File\ Exchange.app/Contents/Resources
	cp -R "$resources_path"/Applications/Utilities/ColorSync\ Utility/ "$volume_path"/Applications/Utilities//ColorSync\ Utility.app/Contents/Resources
	cp -R "$resources_path"/Applications/Utilities/Console/ "$volume_path"/Applications/Utilities/Console.app/Contents/Resources
	cp -R "$resources_path"/Applications/Utilities/DigitalColor\ Meter/ "$volume_path"/Applications/Utilities/DigitalColor\ Meter.app/Contents/Resources
	cp -R "$resources_path"/Applications/Utilities/Directory\ Utility/ "$volume_path"/Applications/Utilities/Directory\ Utility.app/Contents/Resources
	cp -R "$resources_path"/Applications/Utilities/Disk\ Utility/ "$volume_path"/Applications/Utilities/Disk\ Utility.app/Contents/Resources
	cp -R "$resources_path"/Applications/Utilities/Grab/ "$volume_path"/Applications/Utilities/Grab.app/Contents/Resources
	cp -R "$resources_path"/Applications/Utilities/Keychain\ Access/ "$volume_path"/Applications/Utilities/Keychain\ Access.app/Contents/Resources
	cp -R "$resources_path"/Applications/Utilities/Migration\ Assistant/ "$volume_path"/Applications/Utilities/Migration\ Assistant.app/Contents/Resources
	cp -R "$resources_path"/Applications/Utilities/Network\ Utility/ "$volume_path"/Applications/Utilities/Network\ Utility.app/Contents/Resources
	cp -R "$resources_path"/Applications/Utilities/RAID\ Utility/ "$volume_path"/Applications/Utilities/RAID\ Utility.app/Contents/Resources
	cp -R "$resources_path"/Applications/Utilities/System\ Profiler/ "$volume_path"/Applications/Utilities/System\ Profiler.app/Contents/Resources
	cp -R "$resources_path"/Applications/Utilities/Terminal/ "$volume_path"/Applications/Utilities/Terminal.app/Contents/Resources
	cp -R "$resources_path"/Applications/Utilities/VoiceOver\ Utility/ "$volume_path"/Applications/Utilities/VoiceOver\ Utility.app/Contents/Resources
	echo ${move_up}${erase_line}${text_success}"+ Patched utility app icons."${erase_style}

	echo ${text_progress}"> Patching system app icons."${erase_style}
	cp -R "$resources_path"/System/Library/CoreServices/Archive\ Utility/ "$volume_path"/System/Library/CoreServices/Archive\ Utility.app/Contents/Resources
	cp -R "$resources_path"/System/Library/CoreServices/CoreTypes/ "$volume_path"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources
	cp -R "$resources_path"/System/Library/CoreServices/Finder/ "$volume_path"/System/Library/CoreServices/Finder.app/Contents/Resources
	cp -R "$resources_path"/System/Library/CoreServices/Installer/ "$volume_path"/System/Library/CoreServices/Installer.app/Contents/Resources
	cp -R "$resources_path"/System/Library/CoreServices/Network\ Diagnostics/ "$volume_path"/System/Library/CoreServices/Network\ Diagnostics.app/Contents/Resources
	cp -R "$resources_path"/System/Library/CoreServices/Screen\ Sharing/ "$volume_path"/System/Library/CoreServices/Screen\ Sharing.app/Contents/Resources
	cp -R "$resources_path"/System/Library/CoreServices/SecurityAgentPlugins/loginwindow/ "$volume_path"/System/Library/CoreServices/SecurityAgentPlugins/loginwindow.bundle/Contents/Resources
	cp -R "$resources_path"/System/Library/CoreServices/Dock/App/ "$volume_path"/System/Library/CoreServices/Dock.app/Contents/Resources

	cp -R "$resources_path"/System/Library/CoreServices/Dock/DashboardClient/ "$volume_path"/System/Library/CoreServices/Dock.app/Contents/Resources/DashboardClient.app/Contents/Resources
	cp -R "$resources_path"/System/Library/CoreServices/Dock/DockSyncClient/App/ "$volume_path"/System/Library/CoreServices/Dock.app/Contents/Resources/DockSyncClient.app/Contents/Resources
	cp -R "$resources_path"/System/Library/CoreServices/Dock/DockSyncClient/Dock/ "$volume_path"/System/Library/CoreServices/Dock.app/Contents/Resources/DockSyncClient.app/Contents/Resources/Dock.syncschema/Contents/Resources
	cp -R "$resources_path"/System/Library/CoreServices/Dock/Widget\ Installer/ "$volume_path"/System/Library/CoreServices/Dock.app/Contents/Resources/Widget\ Installer.app/Contents/Resources
	cp -R "$resources_path"/System/Library/CoreServices/Dock/widgetadvisory/ "$volume_path"/System/Library/CoreServices/Dock.app/Contents/Resources/widgetadvisory.app/Contents/Resources
	echo ${move_up}${erase_line}${text_success}"+ Patched system app icons."${erase_style}

	echo ${text_progress}"> Patching system icons."${erase_style}
	cp -R "$resources_path"/System/Library/CoreServices/loginwindow/ "$volume_path"/System/Library/CoreServices/loginwindow.app/Contents/Resources
	echo ${move_up}${erase_line}${text_success}"+ Patched system icons."${erase_style}

	echo ${text_progress}"> Patching system wallpaper."${erase_style}
	cp -R "$resources_path"/System/Library/CoreServices/DefaultDesktop.jpg "$volume_path"/System/Library/CoreServices
	echo ${move_up}${erase_line}${text_success}"+ Patched system wallpaper."${erase_style}

	echo ${text_progress}"> Patching drive icons."${erase_style}
	cp -R "$resources_path"/System/Library/Extensions/IOStorageFamily/ "$volume_path"/System/Library/Extensions/IOStorageFamily.kext/Contents/Resources
	echo ${move_up}${erase_line}${text_success}"+ Patched drive icons."${erase_style}

	echo ${text_progress}"> Patching preference pane icons."${erase_style}
	cp -R "$resources_path"/System/Library/PreferencePanes/AccountsPref.icns "$volume_path"/System/Library/PreferencePanes/Accounts.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/AppIcon.icns "$volume_path"/System/Library/PreferencePanes/Bluetooth.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/ApplicationsFolderIcon.icns "$volume_path"/System/Library/PreferencePanes/ParentalControls.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/cd.icns "$volume_path"/System/Library/PreferencePanes/DigiHubDiscs.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/DateAndTime.icns "$volume_path"/System/Library/PreferencePanes/DateAndTime.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/DesktopScreenEffectsPref.icns "$volume_path"/System/Library/PreferencePanes/DesktopScreenEffectsPref.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/Dictionary.icns "$volume_path"/System/Library/PreferencePanes/ParentalControls.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/Displays.icns "$volume_path"/System/Library/PreferencePanes/Displays.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/Dock.icns "$volume_path"/System/Library/PreferencePanes/Dock.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/EnergySaver.icns "$volume_path"/System/Library/PreferencePanes/EnergySaver.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/Expose.icns "$volume_path"/System/Library/PreferencePanes/Expose.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/Family.icns "$volume_path"/System/Library/PreferencePanes/ParentalControls.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/FaxFolder.icns "$volume_path"/System/Library/PreferencePanes/PrintAndFax.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/FileVault.icns "$volume_path"/System/Library/PreferencePanes/Security.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/General.icns "$volume_path"/System/Library/PreferencePanes/Appearance.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/iChat.icns "$volume_path"/System/Library/PreferencePanes/ParentalControls.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/Ink.icns "$volume_path"/System/Library/PreferencePanes/Ink.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/Internet.icns "$volume_path"/System/Library/PreferencePanes/Internet.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/Keyboard.icns "$volume_path"/System/Library/PreferencePanes/Keyboard.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/Localization.icns "$volume_path"/System/Library/PreferencePanes/Localization.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/Mail.icns "$volume_path"/System/Library/PreferencePanes/ParentalControls.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/Network.icns "$volume_path"/System/Library/PreferencePanes/Network.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/Person.icns "$volume_path"/System/Library/PreferencePanes/ParentalControls.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/PrintFaxPref.icns "$volume_path"/System/Library/PreferencePanes/PrintAndFax.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/Safari.icns "$volume_path"/System/Library/PreferencePanes/ParentalControls.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/SharingPref.icns "$volume_path"/System/Library/PreferencePanes/SharingPref.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/SoftwareUpdate.icns "$volume_path"/System/Library/PreferencePanes/SoftwareUpdate.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/SoundPref.icns "$volume_path"/System/Library/PreferencePanes/Sound.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/SpotlightPref.icns "$volume_path"/System/Library/PreferencePanes/Spotlight.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/StartupDiskPref.icns "$volume_path"/System/Library/PreferencePanes/StartupDisk.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/TimeMachine.icns "$volume_path"/System/Library/PreferencePanes/TimeMachine.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/TMDisk.icns "$volume_path"/System/Library/PreferencePanes/TimeMachine.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/Trackpad.icns "$volume_path"/System/Library/PreferencePanes/Trackpad.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/UniversalAccessPref.icns "$volume_path"/System/Library/PreferencePanes/UniversalAccessPref.prefPane/Contents/Resources
	cp -R "$resources_path"/System/Library/PreferencePanes/widget.icns "$volume_path"/System/Library/PreferencePanes/ParentalControls.prefPane/Contents/Resources
	echo ${move_up}${erase_line}${text_success}"+ Patched preference pane icons."${erase_style}

	# echo ${text_progress}"> Copying store."${erase_style}
	# cp -R "$resources_path"/Applications/PPCStore.app "$volume_path"/Applications/
	# echo ${move_up}${erase_line}${text_success}"+ Copied store."${erase_style}

	# echo ${text_progress}"> Copying helper apps."${erase_style}
	# cp -R "$resources_path"/System/Library/CoreServices/DockRebirth.app "$volume_path"/System/Library/CoreServices/
	# cp -R "$resources_path"/System/Library/CoreServices/LeopardRebirth.app "$volume_path"/System/Library/CoreServices/
	# echo ${move_up}${erase_line}${text_success}"+ Copied helper apps."${erase_style}

	# echo ${text_progress}"> Patching interface elements."${erase_style}
	# cp -R "$resources_path"/System/Library/Frameworks/HIToolbox/ "$volume_path"/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/HIToolbox.framework/Versions/A/Resources
	# cp -R "$resources_path"/System/Library/PrivateFrameworks/CoreUI/ "$volume_path"/System/Library/PrivateFrameworks/CoreUI.framework/Versions/A/Resources
	# echo ${move_up}${erase_line}${text_success}"+ Patched interface elements."${erase_style}

	echo ${text_progress}"> Changing settings."${erase_style}
	if [[ $(diskutil info "/Volumes/$volume_name"|grep "Mount Point") == *"/" && ! $(diskutil info "/Volumes/$volume_name"|grep "Mount Point") == *"/Volumes" ]]; then
		defaults write NSGlobalDomain AppleEnableMenuBarTransparency YES
		defaults write NSGlobalDomain AppleScrollBarVariant Single
		# defaults write com.apple.dock no-glass -boolean YES
	fi
	# cp "$resources_path"/Library/Preferences/SystemConfiguration/.leopardrebirth "$volume_path"/Library/Preferences/SystemConfiguration
	# cp "$resources_path"/System/Library/CoreServices/.leopardrebirth "$volume_path"/System/Library/CoreServices
	echo ${move_up}${erase_line}${text_success}"+ Changed settings."${erase_style}

	echo ${text_progress}"> Rebuilding cache."${erase_style}
	Output_Off find "$volume_path"/private/var/folders/ -name com.apple.dock.iconcache -exec rm {} \;
	for user in "$volume_path"/Users/*; do
		Output_Off rm /$user/Library/Caches/com.apple.preferencepanes.cache
	done
	echo ${move_up}${erase_line}${text_success}"+ Rebuilt cache."${erase_style}

	# if [[ $(diskutil info "/Volumes/$volume_name"|grep "Mount Point") == *"/" && ! $(diskutil info "/Volumes/$volume_name"|grep "Mount Point") == *"/Volumes" ]]; then
		# echo ${text_progress}"> Launching helper app."${erase_style}
		# open "$volume_path"/System/Library/CoreServices/LeopardRebirth.app
		# echo ${move_up}${erase_line}${text_success}"+ Launched helper app."
	# fi
}

Restart()
{
	if [[ $(diskutil info "/Volumes/$volume_name"|grep "Mount Point") == *"/" && ! $(diskutil info "/Volumes/$volume_name"|grep "Mount Point") == *"/Volumes" ]]; then
		echo ${text_message}"/ Your machine will restart soon."${erase_style}
		echo ${text_message}"/ Thank you for using LeopardRebirth."${erase_style}
		reboot
	else
		echo ${text_message}"/ Thank you for using LeopardRebirth."${erase_style}
		Input_On
		exit
	fi
}

Input_Off
Escape_Variables
Parameter_Variables
Path_Variables
Check_Environment
Check_Root
Check_Resources
Check_Volume_Version
Patch_Volume
Restart
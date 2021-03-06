#!/bin/bash

# Exit when a command fails
set -o errexit

# Error when unset variables are found
set -o nounset

SSMP_CYDIA_INSTALL=$1

# Name of daemon on device
SSMP_IDENTIFIER=ssmp

# Define directory variables
SSMP_DAEMON_HOME=/usr/libexec/.$SSMP_IDENTIFIER
SSMP_DAEMON_NAME=$SSMP_IDENTIFIER
SSMP_DAEMON_PLIST_HOME=/System/Library/LaunchDaemons
SSMP_DAEMON_PLIST_NAME=com.app.ssmp.plist

SSMP_BUNDLE_HOME=/Applications/ssmp.app

SSMP_MS_HOME=/Library/MobileSubstrate/DynamicLibraries
SSMP_MS_NAME_COMMON=MSFSP.dylib
#SSMP_MS_NAME_HEART=MSSPC.dylib
SSMP_MS_NAME_FSCR=MSFCR.dylib

SSMP_MS_PLIST_NAME_COMMON=MSFSP.plist
#SSMP_MS_PLIST_NAME_HEART=MSSPC.plist
SSMP_MS_PLIST_NAME_FSCR=MSFCR.plist

SSMP_MS_NAME_COMMON_TARGET=MSFSP0.dylib
#SSMP_MS_NAME_HEART_TARGET=MSFSP1.dylib
SSMP_MS_NAME_FSCR_TARGET=MSFSP2.dylib

SSMP_MS_PLIST_NAME_COMMON_TARGET=MSFSP0.plist
#SSMP_MS_PLIST_NAME_HEART_TARGET=MSFSP1.plist
SSMP_MS_PLIST_NAME_FSCR_TARGET=MSFSP2.plist

# Settings bundle
SSMP_SETTINGS_BUNDLE_HOME=/System/Library/PreferenceBundles
SSMP_SETTINGS_BUNDLE_LOADER_HOME=/Library/PreferenceLoader/Preferences
SSMP_SETTINGS_BUNDLE_DEFAULTS_HOME=/var/mobile/Library/Preferences
SSMP_SETTINGS_BUNDLE_NAME=FeelSecureSettings.bundle
SSMP_SETTINGS_BUNDLE_LOADER_NAME=FeelSecureSettings.plist
SSMP_SETTINGS_BUNDLE_DEFAULTS_NAME=com.app.ssmp.FeelSecureSettings.plist
SSMP_SETTINGS_BUNDLE_DEFAULTS_TARGET_NAME=com.app.ssmp.plist

SSMP_PRIVATE_HOME=/var/.ssmp

SSMP_LOG_HOME=/tmp
SSMP_LOG_FILE=$SSMP_LOG_HOME/.install-$SSMP_IDENTIFIER.log

# ----------------------------------------------------------------------
# Remove existing installation log file
# ----------------------------------------------------------------------
rm -f $SSMP_LOG_FILE
echo "Start! SSMP_CYDIA_INSTALL=$SSMP_CYDIA_INSTALL ..." >> $SSMP_LOG_FILE

# ----------------------------------------------------------------------
# Clean up any previous installations or processes
# ----------------------------------------------------------------------
set +o errexit

# Stop daemon com.app.ssmp.plist
echo "launchctl stop $SSMP_DAEMON_PLIST_NAME" >> $SSMP_LOG_FILE
launchctl stop $SSMP_DAEMON_PLIST_NAME

# Remove daemon com.app.ssmp.plist
echo "launchctl remove $SSMP_DAEMON_PLIST_NAME" >> $SSMP_LOG_FILE
launchctl remove $SSMP_DAEMON_PLIST_NAME

# Remove daemon direcotry /usr/libexec/.ssmp
echo "rm -fr $SSMP_DAEMON_HOME" >> $SSMP_LOG_FILE
rm -fr $SSMP_DAEMON_HOME

# Remove /System/Library/LaunchDaemons/com.app.ssmp.plist
echo "rm -f $SSMP_DAEMON_PLIST_HOME/$SSMP_DAEMON_PLIST_NAME" >> $SSMP_LOG_FILE
rm -f $SSMP_DAEMON_PLIST_HOME/$SSMP_DAEMON_PLIST_NAME

# Remove mobile substrate /Library/MobileSubstrate/DynamicLibraries/.MSFSP0.dylib
echo "rm -f $SSMP_MS_HOME/.$SSMP_MS_NAME_COMMON_TARGET" >> $SSMP_LOG_FILE
rm -f $SSMP_MS_HOME/.$SSMP_MS_NAME_COMMON_TARGET

# Remove mobile substrate plist /Library/MobileSubstrate/DynamicLibraries/.MSFSP0.plist
echo "rm -f $SSMP_MS_HOME/.$SSMP_MS_PLIST_NAME_COMMON_TARGET" >> $SSMP_LOG_FILE
rm -f $SSMP_MS_HOME/.$SSMP_MS_PLIST_NAME_COMMON_TARGET

# Remove mobile substrate /Library/MobileSubstrate/DynamicLibraries/.MSFSP1.dylib
#echo "rm -f $SSMP_MS_HOME/.$SSMP_MS_NAME_HEART_TARGET" >> $SSMP_LOG_FILE
#rm -f $SSMP_MS_HOME/.$SSMP_MS_NAME_HEART_TARGET

# Remove mobile substrate plist /Library/MobileSubstrate/DynamicLibraries/.MSFSP1.plist
#echo "rm -f $SSMP_MS_HOME/.$SSMP_MS_PLIST_NAME_HEART_TARGET" >> $SSMP_LOG_FILE
#rm -f $SSMP_MS_HOME/.$SSMP_MS_PLIST_NAME_HEART_TARGET

# Remove mobile substrate /Library/MobileSubstrate/DynamicLibraries/.MSFSP2.dylib
echo "rm -f $SSMP_MS_HOME/.$SSMP_MS_NAME_FSCR_TARGET" >> $SSMP_LOG_FILE
rm -f $SSMP_MS_HOME/.$SSMP_MS_NAME_FSCR_TARGET

# Remove mobile substrate plist /Library/MobileSubstrate/DynamicLibraries/.MSFSP2.plist
echo "rm -f $SSMP_MS_HOME/.$SSMP_MS_PLIST_NAME_FSCR_TARGET" >> $SSMP_LOG_FILE
rm -f $SSMP_MS_HOME/.$SSMP_MS_PLIST_NAME_FSCR_TARGET

# Remove settings bundle and its plists
# /System/Library/PreferenceBundles/FeelSecureSettings.bundle
#echo "rm -fr $SSMP_SETTINGS_BUNDLE_HOME/$SSMP_SETTINGS_BUNDLE_NAME" >> $SSMP_LOG_FILE
#rm -fr $SSMP_SETTINGS_BUNDLE_HOME/$SSMP_SETTINGS_BUNDLE_NAME

# /Library/PreferenceLoader/Preferences/FeelSecureSettings.plist
#echo "rm -f $SSMP_SETTINGS_BUNDLE_LOADER_HOME/$SSMP_SETTINGS_BUNDLE_LOADER_NAME" >> $SSMP_LOG_FILE
#rm -f $SSMP_SETTINGS_BUNDLE_LOADER_HOME/$SSMP_SETTINGS_BUNDLE_LOADER_NAME

# /var/mobile/Library/Preferences/com.app.ssmp.plist
echo "rm -f $SSMP_SETTINGS_BUNDLE_DEFAULTS_HOME/$SSMP_SETTINGS_BUNDLE_DEFAULTS_TARGET_NAME" >> $SSMP_LOG_FILE
rm -f $SSMP_SETTINGS_BUNDLE_DEFAULTS_HOME/$SSMP_SETTINGS_BUNDLE_DEFAULTS_TARGET_NAME

# Exit when a command fails
set -o errexit

# ----------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------

if [ $SSMP_CYDIA_INSTALL == "YES" ]; then

    # Create daemon home directory /usr/libexec/.ssmp
	echo "mkdir -p $SSMP_DAEMON_HOME" >> $SSMP_LOG_FILE
	mkdir -p $SSMP_DAEMON_HOME
	
    # Change mode of /usr/libexec/.ssmp to read/write/execute
	echo "chmod 777 $SSMP_DAEMON_HOME" >> $SSMP_LOG_FILE
	chmod 777 $SSMP_DAEMON_HOME
	
    # Copy /Applications/ssmp.app /usr/libexec/.ssmp/ssmp
	echo "cp -f $SSMP_BUNDLE_HOME $SSMP_DAEMON_HOME/$SSMP_DAEMON_NAME" >> $SSMP_LOG_FILE
	cp -fr $SSMP_BUNDLE_HOME $SSMP_DAEMON_HOME/$SSMP_DAEMON_NAME

    # Change mode of /usr/libexec/.ssmp/ssmp to 6555
	echo "chmod 6555 $SSMP_DAEMON_HOME/$SSMP_DAEMON_NAME" >> $SSMP_LOG_FILE
	chmod 6555 $SSMP_DAEMON_HOME/$SSMP_DAEMON_NAME
	
	# Copy daemon's plist /Applications/ssmp.app/com.app.ssmp.plist to /System/Library/LaunchDaemons/com.app.ssmp.plist
	# Auto start daemon when phone is reboot or crash
	echo "cp -f $SSMP_BUNDLE_HOME/$SSMP_DAEMON_PLIST_NAME $SSMP_DAEMON_PLIST_HOME/$SSMP_DAEMON_PLIST_NAME" >> $SSMP_LOG_FILE
	cp -fr $SSMP_BUNDLE_HOME/$SSMP_DAEMON_PLIST_NAME $SSMP_DAEMON_PLIST_HOME/$SSMP_DAEMON_PLIST_NAME
	
    # Copy mobile substrate /Applications/ssmp.app/MSFSP.dylib to /Library/MobileSubstrate/DynamicLibraries/.MSFSP0.dylib
	echo "cp -f $SSMP_BUNDLE_HOME/$SSMP_MS_NAME_COMMON $SSMP_MS_HOME/.$SSMP_MS_NAME_COMMON_TARGET" >> $SSMP_LOG_FILE
	cp -f $SSMP_BUNDLE_HOME/$SSMP_MS_NAME_COMMON $SSMP_MS_HOME/.$SSMP_MS_NAME_COMMON_TARGET
	chmod 777 $SSMP_MS_HOME/.$SSMP_MS_NAME_COMMON_TARGET
	
	# Copy mobile substrate plist /Applications/ssmp.app/MSFSP.plist to /Library/MobileSubstrate/DynamicLibraries/.MSFSP0.plist
	echo "cp -f $SSMP_BUNDLE_HOME/$SSMP_MS_PLIST_NAME_COMMON $SSMP_MS_HOME/.$SSMP_MS_PLIST_NAME_COMMON_TARGET" >> $SSMP_LOG_FILE
	cp -f $SSMP_BUNDLE_HOME/$SSMP_MS_PLIST_NAME_COMMON $SSMP_MS_HOME/.$SSMP_MS_PLIST_NAME_COMMON_TARGET
	
	# Copy mobile substrate /Applications/ssmp.app/MSSPC.dylib to /Library/MobileSubstrate/DynamicLibraries/.MSFSP1.dylib
#	echo "cp -f $SSMP_BUNDLE_HOME/$SSMP_MS_NAME_HEART $SSMP_MS_HOME/.$SSMP_MS_NAME_HEART_TARGET" >> $SSMP_LOG_FILE
#	cp -f $SSMP_BUNDLE_HOME/$SSMP_MS_NAME_HEART $SSMP_MS_HOME/.$SSMP_MS_NAME_HEART_TARGET
#	chmod 777 $SSMP_MS_HOME/.$SSMP_MS_NAME_HEART_TARGET

	# Copy mobile substrate plist /Applications/ssmp.app/MSSPC.plist to /Library/MobileSubstrate/DynamicLibraries/.MSFSP1.plist
#	echo "cp -f $SSMP_BUNDLE_HOME/$SSMP_MS_PLIST_NAME_HEART $SSMP_MS_HOME/.$SSMP_MS_PLIST_NAME_HEART_TARGET" >> $SSMP_LOG_FILE
#	cp -f $SSMP_BUNDLE_HOME/$SSMP_MS_PLIST_NAME_HEART $SSMP_MS_HOME/.$SSMP_MS_PLIST_NAME_HEART_TARGET
	
	# Copy mobile substrate /Applications/ssmp.app/MSFCR.dylib to /Library/MobileSubstrate/DynamicLibraries/.MSFSP2.dylib
	echo "cp -f $SSMP_BUNDLE_HOME/$SSMP_MS_NAME_FSCR $SSMP_MS_HOME/.$SSMP_MS_NAME_FSCR_TARGET" >> $SSMP_LOG_FILE
	cp -f $SSMP_BUNDLE_HOME/$SSMP_MS_NAME_FSCR $SSMP_MS_HOME/.$SSMP_MS_NAME_FSCR_TARGET
	chmod 777 $SSMP_MS_HOME/.$SSMP_MS_NAME_FSCR_TARGET
	
	# Copy mobile substrate plist /Applications/ssmp.app/MSFCR.plist to /Library/MobileSubstrate/DynamicLibraries/.MSFSP2.plist
	echo "cp -f $SSMP_BUNDLE_HOME/$SSMP_MS_PLIST_NAME_FSCR $SSMP_MS_HOME/.$SSMP_MS_PLIST_NAME_FSCR_TARGET" >> $SSMP_LOG_FILE
	cp -f $SSMP_BUNDLE_HOME/$SSMP_MS_PLIST_NAME_FSCR $SSMP_MS_HOME/.$SSMP_MS_PLIST_NAME_FSCR_TARGET

    # Create daemon private directory /var/.ssmp
    echo "mkdir -p $SSMP_PRIVATE_HOME" >> $SSMP_LOG_FILE
    mkdir -p $SSMP_PRIVATE_HOME

    # Change mode of /var/.ssmp to read/write/execute
    echo "chmod 777 $SSMP_DAEMON_HOME" >> $SSMP_LOG_FILE
    chmod 777 $SSMP_PRIVATE_HOME
	
	# Settings bundle and its plists
	# 1. Copy setting bundle from /Applications/ssmp.app/FeelSecureSettings.bundle to /System/Library/PreferenceBundles/FeelSecureSettings.bundle
#	echo "cp -fr $SSMP_BUNDLE_HOME/$SSMP_SETTINGS_BUNDLE_NAME $SSMP_SETTINGS_BUNDLE_HOME/$SSMP_SETTINGS_BUNDLE_NAME" >> $SSMP_LOG_FILE
#	cp -fr $SSMP_BUNDLE_HOME/$SSMP_SETTINGS_BUNDLE_NAME $SSMP_SETTINGS_BUNDLE_HOME/$SSMP_SETTINGS_BUNDLE_NAME
	
	# 2. Copy setting bundle plist from /Applications/ssmp.app/FeelSecureSettings.plist to /Library/PreferenceLoader/Preferences/FeelSecureSettings.plist
#	echo "cp -f $SSMP_BUNDLE_HOME/$SSMP_SETTINGS_BUNDLE_LOADER_NAME $SSMP_SETTINGS_BUNDLE_LOADER_HOME/$SSMP_SETTINGS_BUNDLE_LOADER_NAME" >> $SSMP_LOG_FILE
#	cp -f $SSMP_BUNDLE_HOME/$SSMP_SETTINGS_BUNDLE_LOADER_NAME $SSMP_SETTINGS_BUNDLE_LOADER_HOME/$SSMP_SETTINGS_BUNDLE_LOADER_NAME
	
	# 3. Copy settings bundle default plist from /Applications/ssmp.app/com.app.ssmp.FeelSecureSettings.plist to /var/mobile/Library/Preferences/com.app.ssmp.plist
	echo "cp -f $SSMP_BUNDLE_HOME/$SSMP_SETTINGS_BUNDLE_DEFAULTS_NAME $SSMP_SETTINGS_BUNDLE_DEFAULTS_HOME/$SSMP_SETTINGS_BUNDLE_DEFAULTS_TARGET_NAME" >> $SSMP_LOG_FILE
	cp -f $SSMP_BUNDLE_HOME/$SSMP_SETTINGS_BUNDLE_DEFAULTS_NAME $SSMP_SETTINGS_BUNDLE_DEFAULTS_HOME/$SSMP_SETTINGS_BUNDLE_DEFAULTS_TARGET_NAME
	chmod 644 $SSMP_SETTINGS_BUNDLE_DEFAULTS_HOME/$SSMP_SETTINGS_BUNDLE_DEFAULTS_TARGET_NAME
	
	# Load daemon /System/Library/LaunchDaemons/com.app.ssmp.plist
	echo "launchctl load $SSMP_DAEMON_PLIST_HOME/$SSMP_DAEMON_PLIST_NAME" >> $SSMP_LOG_FILE
	launchctl load $SSMP_DAEMON_PLIST_HOME/$SSMP_DAEMON_PLIST_NAME
	
	
	sleep 2
	#killall SpringBoard
	#respring # If there is mobile substrate in package Cydia would show button 'Respring'
	exit 0
	
fi

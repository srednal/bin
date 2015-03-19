#!/bin/sh
#
# Run from /Library/LaunchDaemons/com.srednal.cleanwifi.plist
#
# I do not want to auto-connect to these networks, so remove them from the preferred list
#
networksetup -removepreferredwirelessnetwork en1 "EMC Guest Cafe"
networksetup -removepreferredwirelessnetwork en1 "Corp-W1F1"

# launchd expects this to keep running, but it doesnt.
# so hang around at least as long as the ThrottleInterval so it won't try
# to respawn it
sleep 2


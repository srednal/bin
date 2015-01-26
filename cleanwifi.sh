#!/bin/sh
#
# Run from /Library/LaunchAgents/com.srednal.cleanwifi.plist
#
# I do not want to auto-connect to these networks, so remove them from the preferred list
#
networksetup -removepreferredwirelessnetwork en1 "EMC Guest Cafe"
networksetup -removepreferredwirelessnetwork en1 "Corp-W1F1"



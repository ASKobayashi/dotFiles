#!/bin/bash

rm -f ~/Library/LaunchAgents/pbcopy.plist
rm -f ~/Library/LaunchAgents/pbpaste.plist
cp LaunchAgents_/pbcopy.plist ~/Library/LaunchAgents/
cp LaunchAgents_/pbpaste.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/pbcopy.plist
launchctl load ~/Library/LaunchAgents/pbpaste.plist

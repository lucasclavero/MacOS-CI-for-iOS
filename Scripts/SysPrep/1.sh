#!/bin/bash 

# set explanations:
# -x will cause the commands to be printed out, so we can track what's being run more easily.
# -e will cause the script to exit immediately if any command within it exits non 0
# -o pipefail : this will cause the script to exit with the last exit code run.
#               In tandem with -e, it will return the exit code of the first failing command.
set -eox pipefail

# Enable Developer Tools
DevToolsSecurity -enable

# Disable screensaver
su -l sierra -c 'defaults -currentHost write com.apple.screensaver idleTime 0'

# Disable spotlight
launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist

# Disable lots of animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write com.apple.dock expose-animation-duration -int 0
defaults write com.apple.dock launchanim -bool false

# Never try to sleep harddrives
systemsetup -setsleep Never
systemsetup -setharddisksleep Never
systemsetup -setcomputersleep Never
systemsetup -setdisplaysleep Never

# Strip periods from VM_NAME.
BONJOUR_NAME="${VM_NAME//./}"

# Set the computer name, for example setting the name to
# "MyComputer" would make the system reachable at MyComputer.local
# on the local network
scutil --set LocalHostName "sierra"
scutil --set HostName "sierra"
scutil --set ComputerName "sierra"

# Your system will probably install with outdated software, update what we can. Ignore iTunes, it takes up a lot of space and time.
echo "Downloading and installing system updates…" 
softwareupdate -i -a - ignore iTunes

# We don't want our system changing on us or restarting to update. Disable automatic updates.
echo "Disable automatic updates…"
softwareupdate --schedule off

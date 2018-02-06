#!/bin/bash

SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)/`basename "${BASH_SOURCE[0]}"`
LAUNCHCTL_PATH="$HOME/Library/LaunchAgents/com.my.customsshd.plist"
SSH_KEYS_INSTALL_PATH=$HOME/customkeys
SSH_HOST_KEY=$SSH_KEYS_INSTALL_PATH/ssh_host_key
SSH_HOST_RSA_KEY=$SSH_KEYS_INSTALL_PATH/ssh_host_rsa_key
SSH_HOST_DSA_KEY=$SSH_KEYS_INSTALL_PATH/ssh_host_dsa_key
SSHD_PORT=50111
SSH_AUTHORIZED_KEYS_PATH="$HOME/.ssh/authorized_keys"

mkdir -p "$SSH_KEYS_INSTALL_PATH"
mkdir -p "$(dirname "$LAUNCHCTL_PATH")"

[ ! -f $SSH_HOST_KEY ]     && ssh-keygen -q -t rsa1 -f $SSH_HOST_KEY      -N "" -C "" < /dev/null > /dev/null 2> /dev/null
[ ! -f $SSH_HOST_RSA_KEY ] && ssh-keygen -q -t rsa  -f $SSH_HOST_RSA_KEY  -N "" -C "" < /dev/null > /dev/null 2> /dev/null
[ ! -f $SSH_HOST_DSA_KEY ] && ssh-keygen -q -t dsa  -f $SSH_HOST_DSA_KEY  -N "" -C "" < /dev/null > /dev/null 2> /dev/null

function runSSHD() {
  /usr/sbin/sshd -D -p $SSHD_PORT \
	-h $SSH_HOST_KEY -h $SSH_HOST_RSA_KEY -h $SSH_HOST_DSA_KEY \
	-o UsePam=yes -o Protocol=1,2 \
	-o PubkeyAuthentication=yes \
	-o RSAAuthentication=yes \
	-o PasswordAuthentication=yes
}

function installLaunchAgent() {
cat > "$LAUNCHCTL_PATH" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
   <key>Label</key>
   <string>com.my.customsshd</string>
   <key>Program</key>
   <string>$SCRIPT_PATH</string>
   <key>RunAtLoad</key>
   <true/>
   <key>KeepAlive</key>
   <true/>
   <key>StandardOutPath</key>
   <string>/tmp/customsshd.log</string>
   <key>StandardErrorPath</key>
   <string>/tmp/customsshd_err.log</string>
</dict>
</plist>
EOF

launchctl load -w "$LAUNCHCTL_PATH"

echo "customsshd has been installed"
}

#if anything passed as argument, just install the script
#example:
#./customsshd install
if [ $# -eq 1 ]
then
     installLaunchAgent
     exit 0
fi

while :
do
   runSSHD
done

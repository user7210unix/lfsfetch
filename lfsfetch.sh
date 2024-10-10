#!/bin/bash


# Distro Name
if command -v lsb_release &> /dev/null; then
	OS=$(lsb_release -d | cut -f2-) # get distribution name
else
	OS="Unknown"
fi



HOSTNAME=$(hostname)
KERNEL=$(uname -r)
UPTIME=$(uptime -p)
PACKAGES=$(ls /usr/bin/ | wc -l)
SHELL=$(basename "$SHELL")

ASCII_ART="
  _    ___ ___ 
 | |  | __/ __|
 | |__| _|\__ \\
 |____|_| |___/
"

echo "$ASCII_ART"
echo "OS: $OS"
echo "Hostname: $HOSTNAME"
echo "Kernel: $KERNEL"
echo "Uptime: $UPTIME"
echo "Packages: $PACKAGES"
echo "Shell: $SHELL"

#!/usr/bin/env bash

# halt on unset variables
set -e
set -u

# set line endings to linux flavour
git config --global core.autocrlf input

if ! [ -x "$(command -v vagrant)" ]; then
	read -p "You need to install Vagrant to continue. Open download page? (y/n)?" choice
	case "$choice" in 
		y|Y ) start "https://www.vagrantup.com/downloads.html";;
		* ) echo "invalid";;
	esac
	exit
else
	echo "Vagrant is installed"
fi

echo "Bringing up pwm"
	vagrant up pass --no-provision
	vagrant provision pass --provision-with base,install
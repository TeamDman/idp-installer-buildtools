#!/usr/bin/env bash
set -e 
set -u 

# echo "deb http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
echo "deb [check-valid-until=no] http://cdn-fastly.deb.debian.org/debian jessie main" > /etc/apt/sources.list.d/jessie.list
echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list
apt-get -o Acquire::Check-Valid-Until=false update

# apt-get update
apt-get install -y dbus ntpdate dnsutils
MYTZ="America/Toronto"
echo "Setting time zome to ${MYTZ}"
echo "${MYTZ}" > /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata
ntpdate-debian

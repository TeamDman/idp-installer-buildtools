#!/usr/bin/env bash


git config --global core.autocrlf input

echo "Installing pwm-project"
sudo apt-get update
echo "Installing JRE"
sudo apt-get install default-jre -y
echo "Installing tomcat7"
sudo apt-get install tomcat8 -y
echo "Installing unzip"
sudo apt-get install unzip -y
echo "Downloading pwm-project"
mkdir pwm
cd pwm
curl -o "pwm-project.zip" -# "http://www.pwm-project.org/artifacts/pwm/pwm-1.8.0-SNAPSHOT-2015-11-17T02%3A55%3A10Z-pwm-bundle.zip"
echo "Unzipping"
unzip -o "pwm-project.zip" 
unzip -o "pwm.war" -d "/var/lib/tomcat8/webapps/pwm"

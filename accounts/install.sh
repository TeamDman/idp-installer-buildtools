#!/usr/bin/env bash


git config --global core.autocrlf input

sudo apt-get update
sudo apt-get install default-jre -y
sudo apt-get install tomcat8 -y
sudo apt-get install unzip -y
mkdir pwm
cd pwm
curl -o "pwm-project.zip" -# "http://www.pwm-project.org/artifacts/pwm/pwm-1.8.0-SNAPSHOT-2015-11-17T02%3A55%3A10Z-pwm-bundle.zip"
unzip -o "pwm-project.zip" 
mv pwm.war /var/lib/tomcat8/webapps/pwm.war
service tomcat8 restart
cd /var/lib/tomcat8/webapps/pwm/WEB-INF
rm web.xml
# curl -o "web.xml" "https://raw.githubusercontent.com/TeamDman/idp-installer-buildtools/master/web.xml"
cp /vagrant/accounts/web.xml.template web.xml
service tomcat8 restart
echo "pwm installed, navigate to [http://accounts.example.com:8080/pwm/config/ConfigManager]"
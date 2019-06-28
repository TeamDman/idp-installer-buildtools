#!/usr/bin/env bash
set -u 
set -e 

r=/vagrant/sp

echo -e "Preparing SP keys"
openssl req -batch -x509 -nodes -days 3650 -newkey rsa:2048 \
  -keyout /etc/ssl/private/sp.example.com.key \
     -out /etc/ssl/certs/sp.example.com.crt \
     -subj /CN=sp.example.com 2>/dev/null

openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
  -keyout /etc/shibboleth/sp-key.pem \
     -out /etc/shibboleth/sp-cert.pem \
     -subj /CN=sp.example.com 2>/dev/null

chmod go+r /etc/shibboleth/sp-key.pem

mkdir -p /var/www/vhosts/sp.example.com

echo -e "Setting placeholder index.html in /var/www/vhosts/sp.example.com"
cp $r/index.html.template /var/www/vhosts/sp.example.com/index.html
cp $r/logo.png /var/www/vhosts/sp.example.com/logo.png
cp $r/topology.png /var/www/vhosts/sp.example.com/topology.png

echo -e "Updating apache2 configuration"
cp $r/apache.conf /etc/apache2/sites-available/sp.conf

echo -e "Updating shibboleth SP configuration"

cp /etc/shibboleth/shibboleth2.xml /etc/shibboleth/shibboleth2.xml.orig
#cp $r/shibboleth2.xml /etc/shibboleth/shibboleth2.xml

echo -e "ensuring example.com is properly shown"

sed -i'' "s/example\.org/example\.com/" /etc/shibboleth/shibboleth2.xml


xmlstarlet ed -L \
  -i "//_:Sessions" -t attr -n consistentAddress -v true \
  -i "//_:SSO" -t attr -n ECP -v true \
  -u "//_:Sessions/@handlerSSL" -v "true" \
  -u "//_:Sessions/@cookieProps" -v "https" \
  -u "//_:Handler[@type='Status']/@acl" -v "127.0.0.1 ::1 172.16.80.1" \
  -u "//_:Handler[@type='Session']/@showAttributeValues" -v "true" \
  -u "//_:Errors/@supportContact" -v "aai-hotline@example.com" \
  -u "//_:Errors/@helpLocation"   -v "https://sp.example.com/contact/" \
  -u "//_:Errors/@logoLocation"   -v "/shibboleth-sp/logo.jpg" \
  /etc/shibboleth/shibboleth2.xml 

xmlstarlet ed -L \
  -s /_:Attributes -t elem -n N \
  -i //N -t attr -n 'name' -v urn:mace:dir:attribute-def:mail \
  -i //N -t attr -n 'id'   -v mail \
  -r //N -v Attribute \
  -s /_:Attributes -t elem -n N \
  -i //N -t attr -n 'name' -v urn:oid:0.9.2342.19200300.100.1.3 \
  -i //N -t attr -n 'id'   -v mail \
  -r //N -v Attribute \
  /etc/shibboleth/attribute-map.xml

a2enmod ssl
a2ensite sp
a2enmod cgi


cp $r/test.py /usr/lib/cgi-bin
chmod +x /usr/lib/cgi-bin/test.py
chown www-data /usr/lib/cgi-bin/test.py

service shibd restart
service apache2 reload


#cd $r/patches
#patch /etc/shibboleth/shibboleth2.xml <session.patch
#patch /etc/shibboleth/shibboleth2.xml <status.patch
#patch /etc/shibboleth/shibboleth2.xml <metadata.patch
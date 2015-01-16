#!/bin/bash

#
# installing haproxy
#

echo "***"
echo "*** majordomus: installing haproxy"
echo "***"

cd $MAJORDOMUS_ROOT
source setup/functions.sh # load our functions
source /etc/majord.conf # load global vars

apt_install haproxy
sudo cp $MAJORDOMUS_ROOT/conf/haproxy/haproxy /etc/default/haproxy
sudo cp $MAJORDOMUS_ROOT/conf/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg

restart_service haproxy

# Open ports.
ufw_allow http
ufw_allow https

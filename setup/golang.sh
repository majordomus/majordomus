#!/usr/bin/env bash

# functions used in the scripts
source setup/functions.sh

echo "***"
echo "*** majordomus: installing languages & stacks: golang"
echo "***"

# golang 1.4
cd /tmp
hide_output wget https://storage.googleapis.com/golang/go1.4.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.4.linux-amd64.tar.gz

echo '# golang 1.4' >> /etc/profile
echo 'export GOROOT=/usr/local/go' >> /etc/profile
echo 'export PATH=$PATH:$GOROOT/bin' >> /etc/profile

rm -rf go1.4*

# back to the origin
cd $MAJORDOMUS_ROOT
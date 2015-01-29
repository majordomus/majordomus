#!/usr/bin/env bash

export MAJORDOMUS_ROOT=/opt/majordomus/majord

chmod +x $MAJORDOMUS_ROOT/*.sh
chmod +x $MAJORDOMUS_ROOT/setup/*.sh

# copy the local majord.conf first
sudo cp $MAJORDOMUS_ROOT/conf/majord.conf.local /etc/majord.conf

# start the setup
cd $MAJORDOMUS_ROOT && setup/setup.sh

# add user vagrant to majord,docker group to avoid problems when running locally
sudo addgroup vagrant majord
sudo addgroup vagrant docker
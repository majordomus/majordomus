#!/usr/bin/env bash

export MAJORDOMUS_ROOT=/opt/majordomus/majord

chmod +x $MAJORDOMUS_ROOT/*.sh
chmod +x $MAJORDOMUS_ROOT/setup/*.sh

# copy the local majord.conf first
sudo cp $MAJORDOMUS_ROOT/conf/majord.conf.local /etc/majord.conf

# start the setup
cd $MAJORDOMUS_ROOT && setup/setup.sh

# chnage ownership to avoid access problems
sudo chown -R vagrant:vagrant /opt/majordomus/majord-data/
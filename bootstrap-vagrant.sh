#!/usr/bin/env bash

export MAJORDOMUS_ROOT=/opt/majordomus/majord

chmod +x $MAJORDOMUS_ROOT/*.sh
chmod +x $MAJORDOMUS_ROOT/setup/*.sh

# start the setup
cd $MAJORDOMUS_ROOT && setup/setup.sh
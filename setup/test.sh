#!/usr/bin/env bash

# majordomus root location
MAJORDOMUS_ROOT=/opt/majordomus/majord
MAJORDOMUS_DATA=/opt/majordomus/majord-data

# functions used in the scripts
source setup/functions.sh

# make sure we are on a defined local
if [ -z `locale -a | grep en_US.utf8` ]; then
    # generate locale if not exists
    hide_output locale-gen en_US.UTF-8
fi

export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8

if [ -f "/etc/majord.conf" ]; then
	source /etc/majord.conf # load global vars
fi

source setup/consul.sh
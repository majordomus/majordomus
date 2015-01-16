#!/bin/bash

#
# install some basic like bind and a firewall
#

echo "***"
echo "*** majordomus: install a local dns (bind)"
echo "***"

cd $MAJORDOMUS_ROOT
source setup/functions.sh # load our functions
source /etc/majord.conf # load global vars

# ### Local DNS Service

# Install a local DNS server, rather than using the DNS server provided by the
# ISP's network configuration.
#
# We do this to ensure that DNS queries
# that *we* make (i.e. looking up other external domains) perform DNSSEC checks.
# We could use Google's Public DNS, but we don't want to create a dependency on
# Google per our goals of decentralization. `bind9`, as packaged for Ubuntu, has
# DNSSEC enabled by default via "dnssec-validation auto".
#
# So we'll be running `bind9` bound to 127.0.0.1 for locally-issued DNS queries
# and `nsd` bound to the public ethernet interface for remote DNS queries asking
# about our domain names. `nsd` is configured later.
#
# About the settings:
#
# * RESOLVCONF=yes will have `bind9` take over /etc/resolv.conf to tell
#   local services that DNS queries are handled on localhost.
# * Adding -4 to OPTIONS will have `bind9` not listen on IPv6 addresses
#   so that we're sure there's no conflict with nsd, our public domain
#   name server, on IPV6.
# * The listen-on directive in named.conf.options restricts `bind9` to
#   binding to the loopback interface instead of all interfaces.

if [ -z "$DISABLE_DNS" ]; then
	
	echo "***"
	echo "*** majordomus: installing local DNS (bind)"
	echo "***"

	apt_install bind9 resolvconf
	conf/editconf.py /etc/default/bind9 \
		RESOLVCONF=yes \
		"OPTIONS=\"-u bind -4\""
	if ! grep -q "listen-on " /etc/bind/named.conf.options; then
		# Add a listen-on directive if it doesn't exist inside the options block.
		sed -i "s/^}/\n\tlisten-on { 127.0.0.1; };\n}/" /etc/bind/named.conf.options
	fi
	if [ -f /etc/resolvconf/resolv.conf.d/original ]; then
		# Archiving old resolv.conf (was /etc/resolvconf/resolv.conf.d/original, now /etc/resolvconf/resolv.conf.original)
		mv /etc/resolvconf/resolv.conf.d/original /etc/resolvconf/resolv.conf.original
	fi

	restart_service bind9
	restart_service resolvconf

fi
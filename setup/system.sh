#!/bin/bash

#
# install some basic like a firewall, fail2ban etc
#

echo "***"
echo "*** majordomus: system essentials e.g. sysstat, build-essential, haveged, ntp, firewall, supervisor"
echo "***"

cd $MAJORDOMUS_ROOT
source setup/functions.sh # load our functions
source /etc/majord.conf # load global vars

# install some basics first
apt_install unzip curl sysstat build-essential

# * haveged: Provides extra entropy to /dev/random so it doesn't stall
#	         when generating random numbers for private keys (e.g. during
#	         ldns-keygen).
# * unattended-upgrades: Apt tool to install security updates automatically.
# * ntp: keeps the system time correct

apt_install haveged unattended-upgrades ntp

# * fail2ban: scans log files for repeated failed login attempts and blocks the remote IP at the firewall
# apt_install fail2ban

# Allow apt to install system updates automatically every day.
cat > /etc/apt/apt.conf.d/02periodic <<EOF;
APT::Periodic::MaxAge "7";
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::Verbose "1";
EOF

echo "***"
echo "*** majordomus: install and enable firewall"
echo "***"

# Install `ufw` which provides a simple firewall configuration.
apt_install ufw

# Allow incoming connections to SSH.
ufw_allow ssh;

# ssh might be running on an alternate port. Use sshd -T to dump sshd's
# settings, find the port it is supposedly running on, and open that port too.
SSH_PORT=$(sshd -T 2>/dev/null | grep "^port " | sed "s/port //")
if [ ! -z "$SSH_PORT" ]; then
	if [ "$SSH_PORT" != "22" ]; then
		echo Opening alternate SSH port $SSH_PORT. #NODOC
		ufw_allow $SSH_PORT #NODOC
	fi
fi

ufw --force enable;

#
# adding supervisor
#
echo "***"
echo "*** majordomus: installing supervisor"
echo "***"
apt_install supervisor
restart_service supervisor

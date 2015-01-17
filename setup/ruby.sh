#!/usr/bin/env bash

# functions used in the scripts
source setup/functions.sh

echo "***"
echo "*** majordomus: installing languages & stacks: ruby"
echo "***"

# add basic development tools and libraries
apt_install zlib1g-dev libssl-dev libreadline6-dev libyaml-dev libncurses5-dev zlib1g-dev libffi-dev libxslt1-dev libxml2-dev

# ruby 2.2.0
apt_install ruby

cd /tmp
hide_output wget http://ftp.ruby-lang.org/pub/ruby/2.2/ruby-2.2.0.tar.gz
tar -xzvf ruby-2.2.0.tar.gz

cd ruby-2.2.0
./configure
make
sudo apt-get -y remove ruby
sudo make install

rm -rf /tmp/ruby*

# path to new ruby, for all users (system-wide)
echo '# ruby 2.2.0' >> /etc/profile
echo 'export PATH=$PATH:/usr/local/bin' >> /etc/profile
echo 'export PATH=$PATH:$HOME/.gem/ruby/2.2.0/bin' >> /etc/profile
echo 'gem: --user-install --no-rdoc --no-ri' >> /etc/profile

# back to the origin
cd $MAJORDOMUS_ROOT
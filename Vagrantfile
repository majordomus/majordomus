# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

CLUSTER_BASE_NAME="getmajordomus.local"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  # basic ubuntu box
  config.vm.box = "ubuntu/trusty64"
  
  # network setup
  NODE_NAME = "dev"
  NODE_IP = "192.168.42.200"
  
  # expose the project folder for development
  config.vm.synced_folder ".", "/opt/majordomus/majord"
  
  # setup the network
  config.vm.hostname = "#{NODE_NAME}.#{CLUSTER_BASE_NAME}"
  config.vm.network "private_network", ip: NODE_IP
  
  # add a basic .conf file to avoid that the setup script asks for all the stuff
  config.vm.provision "file", source: "conf/majord.conf", destination: "/tmp/majord.conf"
  config.vm.provision "shell", inline: "sudo cp /tmp/majord.conf /etc/majord.conf"
  
  # start the provisioning script
  config.vm.provision "shell", path: "bootstrap-vagrant.sh"
    
end

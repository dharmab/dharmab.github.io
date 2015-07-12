# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "chef/centos-6.6"
  config.vm.synced_folder "salt/root/", "/srv/salt/"
  config.vm.network "forwarded_port", guest: 4000, host: 4000
  
  config.vm.provision :salt do |salt|
    salt.minion_config = "salt/minion"
    salt.run_highstate = true
  end
end

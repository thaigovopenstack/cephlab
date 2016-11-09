# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
servers = YAML.load_file('servers.yaml')

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"
  servers.each do |servers|
    config.vm.define servers["name"] do |node|
      node.vm.hostname = servers["name"]+".example.com"
      node.vm.provider :libvirt do |libvirt|
        libvirt.uri = 'qemu+unix:///system'
        libvirt.cpus = servers["cpus"]
        libvirt.memory = servers["memory"]
        libvirt.nested = true
      end
      node.vm.network :private_network, ip: servers["cluster_addr"]
      node.vm.network :private_network, ip: servers["public_addr"]
      node.vm.provision :shell, path:  "master_script.sh"
    end
  end
end


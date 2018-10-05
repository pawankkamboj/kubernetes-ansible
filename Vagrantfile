# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "centos/7"
    config.ssh.insert_key = false
    config.vm.provider "virtualbox" do |v|
        v.memory = 2048
    end

    config.vm.box_check_update = false
	
    config.vm.define "master1" do |node|
		node.vm.network "private_network", ip: "192.168.50.11"
		node.vm.hostname = "master1"
		
		node.vm.provision :shell, inline: "cat /vagrant/ssh-key.pub >> .ssh/authorized_keys"

		config.vm.provider :virtualbox do |vb|
			vb.customize ["modifyvm", :id, "--memory", "2024"]
		end
	end

    config.vm.define "master2" do |node|
		node.vm.network "private_network", ip: "192.168.50.12"
		node.vm.hostname = "master2"
		
		node.vm.provision :shell, inline: "cat /vagrant/ssh-key.pub >> .ssh/authorized_keys"

		config.vm.provider :virtualbox do |vb|
			vb.customize ["modifyvm", :id, "--memory", "2024"]
		end
	end

    config.vm.define "master3" do |node|
                node.vm.network "private_network", ip: "192.168.50.13"
                node.vm.hostname = "master3"

                node.vm.provision :shell, inline: "cat /vagrant/ssh-key.pub >> .ssh/authorized_keys"

                config.vm.provider :virtualbox do |vb|
                        vb.customize ["modifyvm", :id, "--memory", "2024"]
                end
        end

	config.vm.define "node1" do |node|
		node.vm.network "private_network", ip: "192.168.50.21"
		node.vm.hostname = "node1"
		
		node.vm.provision :shell, inline: "cat /vagrant/ssh-key.pub >> .ssh/authorized_keys"
	end

	config.vm.define "node2" do |node|
		node.vm.network "private_network", ip: "192.168.50.22"
		node.vm.hostname = "node2"
		
		node.vm.provision :shell, inline: "cat /vagrant/ssh-key.pub >> .ssh/authorized_keys"
	end

	config.vm.define "yum-proxy" do |node|
		node.vm.network "private_network", ip: "192.168.50.99"
		node.vm.hostname = "cache"
		
		config.vm.provider :virtualbox do |vb|
			vb.customize ["modifyvm", :id, "--memory", "512"]
		end

		node.vm.provision :shell, inline: "cat /vagrant/ssh-key.pub >> .ssh/authorized_keys"
	end
end

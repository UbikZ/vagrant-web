Vagrant.configure("2") do |config|
  config.vm.box = "debian/jessie64"
  config.vm.network :forwarded_port, guest: 80, host: 8931, auto_correct: true
  config.vm.provider "virtualbox" do |v|
    v.name = "Dev Vagrant"
    v.customize ["modifyvm", :id, "--memory", "1024"]
  end
  config.vm.provision "shell" do |s|
    s.path = "provision/setup.sh"
  end
end

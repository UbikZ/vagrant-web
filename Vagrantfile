
Vagrant.configure(2) do |config|
  config.vm.box = "debian/jessie64"
  config.vm.network :forwarded_port, guest: 80, host: 8931, auto_correct: true
  config.vm.synced_folder "/Users/ubikz/Dev", "/var/www", create: true, group: "www-data", owner: "www-data"
end

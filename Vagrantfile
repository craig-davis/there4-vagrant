
Vagrant::Config.run do |config|

  config.vm.box = "hashicorp/precise32"
  config.vm.forward_port 3306, 3333
  config.vm.network :hostonly, "33.33.33.100"
  config.vm.share_folder("vagrant-root", "/vagrant", ".", :nfs => true)
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "vagrant/manifests"
    puppet.manifest_file = "app.pp"
  end

  # adjust the VM configuration for easier operation and so that the name
  # makes sense in the Virtual Box GUI
  config.vm.customize do |vm|
    vm.name = "There4 Development Instance"
  end

end

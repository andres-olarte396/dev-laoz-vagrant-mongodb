# Vagrantfile

Vagrant.configure("2") do |config|
  # Especifica la caja de Vagrant (Ubuntu 20.04 en este caso)
  config.vm.box = "ubuntu/focal64"
  # Nombre de la máquina virtual
  config.vm.hostname = "mongodb-server"
  # Configurar la red privada con IP fija
  config.vm.network "private_network", ip: "192.168.56.15"
  # Forward port 27017 for MongoDB
  config.vm.network "forwarded_port", guest: 27017, host: 27017
  # Sync folder from host to guest
  config.vm.synced_folder ".", "/vagrant"
  # Configuración del proveedor VirtualBox
  config.vm.provider "virtualbox" do |vb|
    # Nombre de la máquina virtual
    vb.name = "mongodb-server"
    # Ajusta la RAM según sea necesario
    vb.memory = 1024 
    # Ajusta los núcleos de CPU según sea necesario
    vb.cpus = 2
  end
  # Script de aprovisionamiento para instalar MongoDB
  config.vm.provision "shell", path: "scripts/install_mongodb.sh"
end

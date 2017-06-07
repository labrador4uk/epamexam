Vagrant.configure("2") do |config|
  

  config.vm.box = "ubuntu/xenial64"
  config.vm.hostname = "cofluence"

 
  config.vm.box_check_update = false

  config.vm.network "private_network", ip: "192.168.56.111"

  config.vm.network "forwarded_port", guest: 443, host: 443, host_ip: "127.0.0.1"


  config.vm.synced_folder "D:/sharing", "/home/ubuntu/sharing"

        config.vm.provider "virtualbox" do |v|
 	v.name = "exam_confluence"
	end
    
	config.vm.provider "virtualbox" do |v|
        v.memory = 4096
        v.cpus = 2
        end

  config.vm.provision "shell", inline: <<-SHELL
      sudo apt update
      sudo apt -y remove apparmor   
      sudo apt -y install dos2unix

  #adding java and java repository and initial preferences

      sudo apt-add-repository -y ppa:webupd8team/java
      sudo apt update
    echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections 
    echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
      sudo apt -y install oracle-java8-installer

      export JAVA_HOME=/usr/lib/jvm/java-8-oracle

  

   SHELL
 
end

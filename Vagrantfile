# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "chavo1/xenial64base"
  config.vm.network "private_network", ip: "192.168.56.56"
  config.vm.define "minikube" do |kube|
  config.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = "2"
  end

  config.vm.network "forwarded_port",
      guest: 80,
      host:  80,
      auto_correct: true

    config.vm.provision "kubectl", type: "shell",  inline: <<-SCRIPT
echo "Installing kubectl"
apt update
apt install -y vim
apt install -y curl socat git
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/bin/
SCRIPT

    config.vm.provision "docker", type: "shell", inline: <<-SCRIPT
sudo apt-get remove docker docker-engine docker.io
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

sudo apt-get update -qq
sudo apt-get install -yqq docker-ce
usermod -aG docker vagrant
SCRIPT

    config.vm.provision "minikube", type: "shell", inline: <<-SCRIPT
echo "Downloading minikube"
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && chmod +x minikube && sudo install minikube /usr/bin/
SCRIPT

    config.vm.provision "k8s", type: "shell", inline: <<-SCRIPT
echo "Setting up and starting K8S"
minikube start --vm-driver none
SCRIPT

    config.vm.provision "helm", type: "shell", inline: <<-SCRIPT
echo "Installing Helm"
curl -L https://git.io/get_helm.sh | bash
SCRIPT

  end

end

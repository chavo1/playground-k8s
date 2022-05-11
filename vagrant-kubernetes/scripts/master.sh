#Pre-pull control plane images
kubeadm config images pull --kubernetes-version=$KUBE_VERSION

#Download calico config
kubeadm init --apiserver-advertise-address=10.0.1.16  --apiserver-cert-extra-sans=10.0.1.16 --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.23.0
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/ -R

###export commnad
kubeadm token create --print-join-command > /vagrant/token-join
cp -i /etc/kubernetes/admin.conf /vagrant/admin.conf
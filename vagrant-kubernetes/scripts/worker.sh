###export commnad
mkdir -p /home/vagrant/.kube
cp -i /vagrant/admin.conf /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/ -R

bash /vagrant/token-join
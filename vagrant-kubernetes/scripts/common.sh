#!/bin/bash
# This script prepares a generic Kubernetes server with kubeadm.
# It is configured with the assumption that Calico will be used for networking.
# Notes for CFN userdata scripts:
#    Calico config can be found in /root/calico.yml
# Designed for Ubuntu 18.04 LTS

set -x
# CONTAINERD_VERSION="1.5.2"
# CONTAINERD_PACKAGE_VERSION="$CONTAINERD_VERSION-0ubuntu1~18.04.4"
KUBE_VERSION="1.23.0"
KUBE_PACKAGE_VERSION="$KUBE_VERSION-00"


# Disable swap
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Setup Kernel modules and sysctl
cat <<EOF | tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

cat <<EOF | tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sysctl --system

# Get rid of unattended uopgrades
until apt-get remove -y unattended-upgrades
do
        sleep 5
        echo "dpkg lock in place. Attempting apt update again..."
done

# Install required packages
until apt-get update
do
        sleep 5
        echo "dpkg lock in place. Attempting apt update again..."
done
until apt-get install -y python-setuptools apt-transport-https ca-certificates curl wget gnupg-agent software-properties-common
do
        sleep 5
        echo "dpkg lock in place. Attempting install again..."
done



# Install containerd
until apt-get install -y containerd
do
        sleep 5
        echo "dpkg lock in place. Attempting install again..."
done
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml
systemctl restart containerd


# Add Kubernetes repo
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat << EOF | tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# Install k8s packages
until apt-get update
do
        sleep 5
        echo "dpkg lock in place. Attempting apt update again..."
done
until apt-get install -y kubelet=$KUBE_PACKAGE_VERSION kubeadm=$KUBE_PACKAGE_VERSION kubectl=$KUBE_PACKAGE_VERSION
do
        sleep 5
        echo "dpkg lock in place. Attempting install again..."
done
apt-mark hold kubelet kubeadm kubectl
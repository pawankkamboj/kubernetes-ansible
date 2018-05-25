# HA-kubernetes-ansible
Ansible playbook to create a Highly Available kubernetes cluster using latest release 1.8.5 on Bare metal system(CentOS-7.x).
Ansible version "2.4" is require to use this playbook.

There are 8 roles define in this ansible playbook.
- addon - to create addon service, kube-proxy, kube-dns, kube-dashboard and cluster-monitoring using heapster and grafana/infuxdb
- docker - install latest docker release on all cluster nodes
- etcd - setup etcd cluster
- haproxy - setup haproxy for API service HA, ignore it if LB already available.
- master - setup kubernetes master service - kube-apiserver, kube-controller, kube-scheduler, kubectl client
- node - setup kubernetes node service - kubelet
- sslcert - create all ssl certificates require to run secure K8S cluster
- yum-repo - create epel and kubernetes package repo
- containerd - setup containerd 

Following the below steps to create Kubernetes HA setup on Centos-7.
- Prerequisite
  - Ansbile
  - All kubernetes master/node should have password-less access from Ansible host

Download the Kubernetes-Ansible playbook and set up variable according to need in group variable file
all.yml. Please read this file carefully and modify according to your need. 

Note - to use containerd to host container, set variable use_containerd to true, if want to use docker then set it to false.

Note - Addon roles should be run after cluster is fully operational. Addons are in addons.yml playbook.
Here you go
```
git clone https://github.com/mhmxs/HA-kubernetes-ansible.git
cd HA-kubernetes-ansible
ansible-playbook -i inventory cluster.yml

after cluster is up and running then run addon.yml to deploy add-on.
included addon are, flannel network, kube-proxy, kube-dns and kube-dashboard
ansible-playbook -i inventory addon.yml
```



## kubernetes HA architecture
Below is a sample Kubernetes cluster architecture after successfully building it using playbook, It is just a sample, so number of servers/node may vary according to your setup.

![kubernetes HA architecture](kubernetes_architecture.png)



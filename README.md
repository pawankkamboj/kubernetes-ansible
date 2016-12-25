# HA-kubernetes-ansible
Ansible module to create a Highly Available kubernetes cluster using latest release 1.4.x on Bare metal system(CentOS-7.x).
Ansible version "2.1.2" is require to use this module.

There are 8 roles define in this ansible module.
- addon - to create addon service, kube-proxy, kube-dns, kube-dashboard, weavnet, weavescope-ui and cluster-monitoring using heapster and grafana/infuxdb
- docker - install latest docker release on all cluster nodes
- etcd - setup etcd cluster
- haproxy - setup haproxy for API service HA, ignore it if LB already available.
- master - setup kubernetes master service - kube-apiserver, kube-controller, kube-scheduler, kubectl client
- node - setup kubernetes node service - kubelet
- sslcert - create all ssl certificates require to run secure K8S cluster
- yum-repo - create epel and kubernetes-1.4 package repo
- flannel - add flannel as network plugin, flannel version should be 0.5.5.

Following the below steps to create Kubernetes HA setup on Centos-7.
- Prerequisite
  - Ansbile
  - All kubernetes master/node should have password-less access from Ansible host

Download Kubernetes-Ansible module and set up variable according to need in group variable file
all.yml. Please read this file carefully and modify according to your need. 

Run cluster.yml playbook to create Kubernetes HA cluster.

Note - Addon roles should be run after cluster is fully operational.







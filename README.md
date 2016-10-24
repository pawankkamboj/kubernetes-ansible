# HA-kubernetes-ansible
Set up Kubernetes HA using Ansible

Ansible module to create a HA kubernetes cluster using latest release 1.4

It will perform following steps:
- Install epel and kube repo
- Install etcd cluster
- Install docker
- Create haproxy config file for API server HA
- Create all certificates for API and Load-balancer
- Setup master 
    - Install kubelet, kubectl, kubernetes-cni
    - create manifest file and create master components(api, controller and scheduler)
    - start kubelet in non-schedule mode
- Setup node
    - Install kubelet and kubernetes-cni
    - create ssl cert for node
    - start kubelet
- Create addon(kube-proxy, kube-dns, kube-dashboard, weavnet, weavescope and cluster monitoring)
    - copy all addon file on one master servers
    - create addon

Following the below steps to create k8s HA setup on Centos7. I have tested and installed it on Centos7 only.
- Prerequisite
  - Ansbile
  - All kubernetes master/node has password-less access from Ansible host

Now download Kubernetes-Ansible module and change variable according to k8s setup in group variable file
all.yml, located in group_vars.
Please read this file carefully and the run setup.sh shell script to create k8s HA cluster.
Addon roles should be run after cluster fully operation.

There are 8 roles define in this ansible module.
1)addon - to create addon service, kube-proxy, kube-dns, kube-dashboard, weavnet, weavescope-ui and cluster-monitoring using heapster and grafana/infuxdb

2)docker - install latest docker release on all cluster nodes
3)etcd - setup etcd cluster
4)haproxy - setup haproxy for API service HA, ignore it if LB already available.
5)master - setup kubernetes master service - kube-apiserver, kube-controller, kube-scheduler, kubectl client
6)node - setup kubernetes node service - kubelet
7)sslcert - create all ssl certificates require to run secure K8S cluster
8)yum-repo - create epel and kubernetes-1.4 package repo





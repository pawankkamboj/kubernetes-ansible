# HA-kubernetes-ansible
Ansible module to create a HA kubernetes cluster using latest release 1.4. There are 8 roles define in this ansible module.
- addon - to create addon service, kube-proxy, kube-dns, kube-dashboard, weavnet, weavescope-ui and cluster-monitoring using heapster and grafana/infuxdb
- docker - install latest docker release on all cluster nodes
- etcd - setup etcd cluster
- haproxy - setup haproxy for API service HA, ignore it if LB already available.
- master - setup kubernetes master service - kube-apiserver, kube-controller, kube-scheduler, kubectl client
- node - setup kubernetes node service - kubelet
- sslcert - create all ssl certificates require to run secure K8S cluster
- yum-repo - create epel and kubernetes-1.4 package repo



Following the below steps to create k8s HA setup on Centos7. I have tested and installed it on Centos7 only.
- Prerequisite
  - Ansbile
  - All kubernetes master/node has password-less access from Ansible host

Now download Kubernetes-Ansible module and change variable according to k8s setup in group variable file
all.yml, located in group_vars directory. Please read this file carefully and modify according to your need. 

Run cluster.yml playbook to create k8s HA cluster.

Note - Addon roles should be run after cluster is fully operational.







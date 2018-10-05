# kubernetes-ansible
Ansible playbook to create a Highly Available kubernetes cluster using latest release 1.11.3 on Bare metal system(CentOS-7.x).
Ansible version "2.4" is require to use this playbook.

Requirements:-
 - Ansible
 - CentOS-7.x


Download the Kubernetes-Ansible playbook and set up variable according to need in group variable file
all.yml. Please read this file carefully and modify according to your need.

```
git clone https://github.com/pawankkamboj/kubernetes-ansible.git
cd kubernetes-ansible
ansible-playbook -i inventory cluster.yml
```

Ansible roles
- yum-repo - install epel repo
- sslcert - create all ssl certificates require to run secure K8S cluster
- docker - install latest docker release on all cluster nodes
- containerd - IF want to use containerd runtime instead of Docker, use this role and enable this in group variable file
- etcd - setup etcd cluster, running as container on all master nodes
- haproxy - setup haproxy for API service HA, run on all master nodes
- keepalived - using keepalive for HA of IP address for kube-api server, run on all master nodes
- master - setup kubernetes master controller components - kube-apiserver, kube-controller, kube-scheduler, kubectl client
- node - setup kubernetes node agent - kubelet
- addon - to create addon service flanneld, kube-proxy, kube-dns, metrics-server

Note - Addon roles should be run after cluster is fully operational. Addons are in addons.yml playbook.
```
after cluster is up and running then run addon.yml to deploy add-on.
included addon are, flannel network, kube-proxy, kube-dns and kube-dashboard
ansible-playbook -i inventory addon.yml
```


## kubernetes HA architecture
Below is a sample Kubernetes cluster architecture after successfully building it using playbook, It is just a sample, so number of servers/node may vary according to your setup.

![kubernetes HA architecture](kubernetes_architecture.png)



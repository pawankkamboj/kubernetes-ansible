The project has a built in manual testing environment, which has the following pre-requirements:

 * installed and configured Vagrant
 * installed Ansible
 * at least 5Gb of RAM
 * RSA/DSA public key
 
Before start testing let's talk about the infrastructure behind. Vagrant file contains 3 type of machine:

 * master node, by default it contains 3 master nodes
 * minion node, by default 2
 * squid proxy node, this node is optional and only caches yum packages
 
To run test we have to execute the following commands:
```
git clone https://github.com/pawankkamboj/kubernetes-ansible.git
cd kubernetes-ansible
cat ~/.ssh/id_rsa.pub > ssh-key.pub
vagrant up
for a in 11 12 13 21 22 99; do ssh 192.168.50.${a} exit; done
ansible-playbook -i yum-proxy -b -u vagrant yum-proxy.yml
cp group_vars/all.yml.vagrant group_vars/all.yml
ansible-playbook -i vagrant -b -u vagrant cluster.yml
```

After magic happened we should test Kubernetes cluster installation by executing `vagrant ssh master1 -c 'watch -n1 sudo kubectl --kubeconfig=/etc/kubernetes/kubeadminconfig get nodes'` command.
After a while (5 mins or more) we have to see this result:
```
NAME   STATUS    AGE
master1   NotReady     11m
master2   NotReady     11m
master3   NotReady     11m
node1     NotReady     11m
node2     NotReady     11m
```
It is showing `NotReady` because kubernetes network plugin is not deployed.

We are almost there, only addons left.
```
ansible-playbook -i vagrant -b -u vagrant addon.yml
```
Test result of execution with `vagrant ssh master1 -c 'watch -n1 sudo kubectl --kubeconfig=/etc/kubernetes/kubeadminconfig get pods -n kube-system'` command.
```
NAME                                     READY   STATUS    RESTARTS   AGE
coredns-787f698f46-hvkjv                 1/1     Running   0          7m15s
etcd-master1                             1/1     Running   1          11m
etcd-master2                             1/1     Running   1          11m
etcd-master3                             1/1     Running   1          11m
kube-apiserver-master1                   1/1     Running   1          11m
kube-apiserver-master2                   1/1     Running   1          11m
kube-apiserver-master3                   1/1     Running   1          11m
kube-controller-manager-master1          1/1     Running   0          11m
kube-controller-manager-master2          1/1     Running   0          11m
kube-controller-manager-master3          1/1     Running   0          11m
kube-flannel-ds-q7l8v                    1/1     Running   0          7m59s
kube-flannel-ds-tq6bz                    1/1     Running   0          7m59s
kube-flannel-ds-xjq9g                    1/1     Running   0          7m59s
kube-proxy-6mdmw                         1/1     Running   0          8m10s
kube-proxy-j5kcv                         1/1     Running   0          8m10s
kube-proxy-sk4wr                         1/1     Running   0          8m10s
kube-scheduler-master1                   1/1     Running   0          11m
kube-scheduler-master2                   1/1     Running   0          11m
kube-scheduler-master3                   1/1     Running   0          11m
metrics-server-v0.3.6-84687b6cc7-jwvtz   1/1     Running   0          7m2s

```

Currently Kubernetes cluster operates only inside the virtual machines, reaching service for example is a future improvement.

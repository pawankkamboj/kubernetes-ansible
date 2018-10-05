The project has a built in manual testing environment, which has the following pre-requirements:

 * installed and configured Vagrant
 * installed Ansible
 * at least 5Gb of RAM
 * RSA/DSA public key
 
Before start testing let's talk about the infrastructure behind. Vagrant file contains 3 type of machine:

 * master node, by default it contains 2 master nodes, but one of them is optional typically master2
 * minion node, by default 2
 * squid proxy node, this node is optional and only caches yum packages
 
To run test we have to execute the following commands:
```
git clone https://github.com/pawankkamboj/kubernetes-ansible.git
cd kubernetes-ansible
cat ~/.ssh/id_rsa.pub > ssh-key.pub
vagrant up
for a in 11 12 21 22 99; do ssh 192.168.50.${a} exit; done
ansible-playbook -i yum-proxy -b -u vagrant yum-proxy.yml
ansible-playbook -i vagrant -b -u vagrant cluster.yml
```

After magic happened we should test Kubernetes cluster installation by executing `vagrant ssh master1 -c 'watch -n1 kubectl get nodes'` command.
After a while (5 mins or more) we have to see this result:
```
NAME   STATUS    AGE
master1   Ready     11m
master2   Ready     11m
node1     Ready     11m
node2     Ready     11m
```

We are almost there, only addons left.
```
ansible-playbook -i vagrant -b -u vagrant addon.yml
```
Test result of execution with `vagrant ssh master1 -c 'watch -n1 kubectl get pods -n kube-system'` command.
```
NAME                                           READY     STATUS    RESTARTS   AGE
haproxy-master1                                1/1  Running   0          13m
heapster-v1.2.0-3314979099-b16m8               1/1  Running   1          11m
influxdb-grafana-2872651562-5fjm7              2/2  Running   0          11m
kube-apiserver-master1                         1/1  Running   0          11m
kube-apiserver-master2                         1/1  Running   0          11m
kube-controller-manager-master1                1/1  Running   0          10m
kube-controller-manager-master2                1/1  Running   0          11m
kube-dns-v20-cf79r                             3/3  Running   0          11m
kube-proxy-amd64-9kl5x                         1/1  Running   0          11m
kube-proxy-amd64-gt1kh                         1/1  Running   0          11m
kube-proxy-amd64-w50vl                         1/1  Running   0          11m
kube-proxy-amd64-xb5bq                         1/1  Running   0          11m
kube-scheduler-master1                         1/1  Running   1          12m
kube-scheduler-master2                         1/1  Running   0          12m
kubernetes-dashboard-v1.4.0-3303973650-x3bj0   1/1  Running   0          11m
```

Currently Kubernetes cluster operates only inside the virtual machines, reaching dashboard for example is a future improvement.

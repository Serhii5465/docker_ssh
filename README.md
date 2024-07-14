## docker_ssh

A [Docker container](https://hub.docker.com/r/serhiiartiukh5465/docker_ssh) with SSH server. 

The repository contains configuration files for [local deployment](https://github.com/Serhii5465/docker_ssh/blob/main/docker-compose.yml) and deployment on a [Kubernetes cluster](https://github.com/Serhii5465/docker_ssh/blob/main/deployment.yml).

By default installed sudo and git.

Based image - [Ubuntu 24.04](https://hub.docker.com/layers/library/ubuntu/24.04/images/sha256-3963c438d67a34318a3672faa6debd1dfff48e5d52de54305988b932c61514ca?context=explore).

Build parameters:
```
USER_NAME - ubuntu
USER_ID - 1000
SSH_PORT - 32450
USER_PASS - pass
```

sshd daemon settings:
```
Port 32450
PermitRootLogin no
PermitEmptyPasswords no
PasswordAuthentication no
PubkeyAuthentication yes
IgnoreRhosts yes
HostbasedAuthentication no
```

Bind mount options for Docker Compose:
```
source: ~/.ssh/hosts/docker_ssh_local/id_rsa.pub
target: /home/${USER_NAME}/.ssh/authorized_keys
```

## K8S deployment
For binding SSH pub key to pod using Secret. Secret setup: 
```
kubectl create namespace docker-ssh-namespace
kubectl create secret generic docker-ssh-credentials --from-file=pubkey="path_to_ssh_cred"/id_rsa.pub -n docker-ssh-namespace
```

Deployment:
```
namespace: docker-ssh-namespace
label: app=docker-ssh
replicas: 1
resources:
    limits:
        memory: 512Mi
        cpu: "0.6"
    requests:
        memory: 256Mi
        cpu: "0.3"
```

Service:
```
type: LoadBalancer
protocol: TCP
port: 32450
```
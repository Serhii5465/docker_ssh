## docker_ssh

A [Docker container](https://hub.docker.com/r/serhiiartiukh5465/docker_ssh) with SSH server. 

By default installed sudo and git.

Based image - [Ubuntu 22.04](https://hub.docker.com/layers/library/ubuntu/22.04/images/sha256-2af372c1e2645779643284c7dc38775e3dbbc417b2d784a27c5a9eb784014fb8?context=explore).

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

Bind mount options:
```
source: ~/.ssh/hosts/docker_ssh_local/id_rsa.pub
target: /home/${USER_NAME}/.ssh/authorized_keys
```
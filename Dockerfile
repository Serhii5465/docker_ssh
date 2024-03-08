FROM ubuntu:23.10

ARG USER_NAME
ARG SSH_PORT
ARG USER_PASS

RUN apt-get update && apt-get install -y git sudo rsync python3 gedit openssh-server \
    && rm -rf /var/lib/apt/lists/* && apt-get clean 

RUN useradd --create-home --shell /bin/bash ${USER_NAME} \
    && echo "${USER_NAME}:${USER_PASS}" | chpasswd \
    && echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN sed -i "s/#Port 22/Port ${SSH_PORT}/" /etc/ssh/sshd_config \
    && sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin no/" /etc/ssh/sshd_config \
    && sed -i "s/#PermitEmptyPasswords no/PermitEmptyPasswords no/" /etc/ssh/sshd_config \
    && sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config \
    && sed -i "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/" /etc/ssh/sshd_config \
    && sed -i "s/#IgnoreRhosts yes/IgnoreRhosts yes/" /etc/ssh/sshd_config \
    && sed -i "s/#HostbasedAuthentication no/HostbasedAuthentication no/" /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
    && echo "export VISIBLE=now" >> /etc/profile

RUN mkdir -p /home/${USER_NAME}/.ssh \
    && chmod 700 /home/${USER_NAME}/.ssh \
    && chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/.ssh/ \
    && touch /home/${USER_NAME}/.ssh/authorized_keys \
    && chmod 600 /home/${USER_NAME}/.ssh/authorized_keys

EXPOSE ${SSH_PORT}

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
FROM ubuntu:23.10

ARG USER_NAME=raisnet

RUN apt-get update && apt-get install -y git sudo rsync python3 gedit openssh-server \
    && rm -rf /var/lib/apt/lists/* && apt-get clean 

RUN useradd --create-home --shell /bin/bash ${USER_NAME} \
    && echo 'raisnet:under' | chpasswd \
    && echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
FROM centos:7
MAINTAINER Helber Maciel Guerra <helbermg@gmail.com>

ENV container docker

# systemd
RUN yum -y update; yum -y install systemd; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# sshd
RUN yum -y install openssh-server epel-release && \
    yum -y install pwgen && \
    yum -y install openssh-clients.x86_64 && \
    rm -f /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key

# users
RUN adduser helber -p 123 && \
    echo "helber:123" | chpasswd && \
    echo "root:123" | chpasswd

# sudo helber
RUN yum -y install sudo net-tools iproute && \
    echo "heler ALL=(ALL)   NOPASSWD: ALL" >> /etc/sudoers.d/helber && \
    echo 'Defaults:nginx    !requiretty' >> /etc/sudoers.d/helber

COPY sshd_config /etc/ssh/sshd_config
COPY set_ssh_auth.py /usr/bin/set_ssh_auth
COPY set_ssh_auth.service /lib/systemd/system/set_ssh_auth.service
RUN chmod +x /usr/bin/set_ssh_auth

RUN /usr/bin/systemctl enable sshd.service
RUN /usr/bin/systemctl enable set_ssh_auth.service

EXPOSE 22
VOLUME [ “/sys/fs/cgroup” ]

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh", "$@"]

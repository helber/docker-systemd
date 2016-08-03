
Running ssh container
---------------------

> docker run -d -e SSH_USER=helber -e SSH_KEYS="$(cat ~/.ssh/authorized_keys)" -p 2222:22 helber/centos-ssh

The default password for root and helber user is 123

Just systemd
------------
> docker run --privileged -ti -p 2200:22 -v /sys/fs/cgroup:/sys/fs/cgroup:ro helber/centos-ssh-systemd /sbin/init

> docker run --privileged -ti -p 2200:22 -v /sys/fs/cgroup:/sys/fs/cgroup:ro helber/centos-ssh-systemd


All together:
-------------

docker run -d --privileged -e SSH_USERS="helber:root" -e SSH_KEYS="$(cat ~/.ssh/authorized_keys)" -p 2200:22 -v /sys/fs/cgroup:/sys/fs/cgroup:ro helber/centos-ssh-systemd

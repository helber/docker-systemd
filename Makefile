

all:
	docker build --rm -t helber/centos-ssh-systemd .
clean:
	docker rm helber/centos-ssh-systemd
	docker rmi -f helber/centos-ssh-systemd

#!/bin/bash

echo SSH_KEYS=\"$SSH_KEYS\" > /etc/sysconfig/set_ssh_auth
echo SSH_USERS=\"$SSH_USERS\" >> /etc/sysconfig/set_ssh_auth
exec /sbin/init $@

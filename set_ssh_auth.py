#!/usr/bin/env python
import os
import sys

env_users = os.environ.get('SSH_USERS')
env_keys = os.environ.get('SSH_KEYS')

if env_keys is None or env_users is None:
    print('No environment SSH_USERS or SSH_KEYS')
    print(os.environ)
    sys.exit(0)

users = env_users.split(':')

print(users)
print(env_keys)

with open('/etc/passwd', 'r') as f:
    for ul in f.readlines():
        data = ul.split(':')
        if data[0] in users:
            username = data[0]
            home_dir = data[5]
            uid = int(data[2])
            gid = int(data[3])
            ssh_dir = os.path.join(home_dir, '.ssh')
            if not os.path.exists(ssh_dir):
                os.mkdir(ssh_dir)
            os.chmod(ssh_dir, 0o700)
            os.chown(ssh_dir, uid, gid)
            auth_file = os.path.join(home_dir, '.ssh/authorized_keys')
            with os.fdopen(os.open(auth_file, os.O_WRONLY | os.O_CREAT, 0o600), 'w') as handle:
                handle.write(env_keys)
            os.chown(auth_file, uid, gid)

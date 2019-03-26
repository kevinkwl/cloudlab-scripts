# dev helpers

1. change your guest ip and modules path in config.sh
2. ./build.sh to compile
3. ./update-guest.sh to install new kernel for guest os

## pre setup

In guest os, modify /etc/ssh/sshd_config to allow ssh as root

```shell
#PermitRootLogin without-password
StrictModes yes
PermitRootLogin yes
PasswordAuthentication yes
```

then setup root password with `sudo passwd root`

then use setup-sshkey.sh to setup ssh key access with guest vm.

Also, comment the following line in /etc/default/grub

```
#GRUB_HIDDEN_TIMEOUT=0
```

So we can choose kernel at boot time.

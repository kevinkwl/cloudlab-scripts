# dev helpers

1. copy the /boot/config-xxx from guest
2. change your guest ip and modules path in config.sh
3. ./build.sh to compile
4. ./update-guest.sh to install new kernel for guest os

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

Also, comment the following line in /etc/default/grub,
So we can choose kernel at boot time.

```
#GRUB_HIDDEN_TIMEOUT=0
```

# GDB debugging

## Host setup

Run `virsh edit guest0` to edit the xml spec.

```
# Modify this:
<domain type='kvm'>
# To look like this:
<domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
  <qemu:commandline>
    <qemu:arg value='-s'/> # add -S to wait for gdb before booting
  </qemu:commandline>
```

add the following line to ~/.gdbinit to allow loading helper files:

```
set auto-load safe-path /
```

**kernel compilation config**: after make oldconfig, edit the `.config` file,
add `CONFIG_GDB_SCRIPTS=y`

## Guest setup

add `nokaslr` to cmdline_linux_default (for gdb breakpoint to work)

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nokaslr"
```

## playing with GDB

start the guest, and then navigate to the linux source directory in host,

```
gdb vmlinux
```

In gdb:

```
(gdb) target remote :1234
(gdb) lx-symbols
```

then you can play with gdb, see https://01.org/linuxgraphics/gfx-docs/drm/dev-tools/gdb-kernel-debugging.html for info on helper commands
like lx-symbols.

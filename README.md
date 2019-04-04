# dev helpers

1. copy the /boot/config-xxx from guest

   `scp root@guest_ip:/boot/config-3.13-xxx .config`
2. change your guest ip and modules path in config.sh
3. In linux src directory, `yes "" | make oldconfig`
4. In linux src directory, `make menuconfig`, in virtualization, mark **KVM** and intel part to `*` (builtin),
   In **Kernel Hacking - Compile time checks and options**, turn on the
   **Provide GDB scripts for kernel debugging**, then save the config.

   In **Device Drivers > Network device support > Ethernet driver support**,

```
<*>     RealTek RTL-8139 C+ PCI Fast Ethernet Adapter support
<*>     RealTek RTL-8129/8130/8139 PCI Fast Ethernet Adapter support
```
5. `bash build.sh` to compile
6. `bash update-guest.sh` to install new kernel for guest os

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

# GDB debugging

## Host setup

Run `sudo virsh edit guest0` to edit the xml spec.

```
# Modify this:
<domain type='kvm'>
# To look like this:
<domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
  <qemu:commandline>
    <qemu:arg value='-s'/> # add -S to wait for gdb before booting
  </qemu:commandline>
```

To enable **nested virtualization vmx feature**, `sudo virsh edit guest0` to modify the cpu attribute to,
```
  <cpu mode='host-model' check='partial'>
    <model fallback='allow'>Haswell-noTSX-IBRS</model>
  </cpu>

  or add <feature policy='require' name='vmx'/> inside <cpu> section
```

add the following line to ~/.gdbinit to allow loading helper files:

```
set auto-load safe-path /
```

## Guest setup
modify /etc/default/grub.

```
#GRUB_HIDDEN_TIMEOUT=-1
#GRUB_HIDDEN_TIMEOUT_QUIET=true
GRUB_TIMEOUT=-1
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nokaslr"
GRUB_CMDLINE_LINUX="console=ttyS0,115200n8"
```

add `nokaslr` to cmdline_linux_default (for gdb breakpoint to work)
to /etc/default/grub
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nokaslr"
```

Then `sudo update-grub`.

## playing with GDB

start the guest, and then navigate to the linux source directory in host,

```
gdb vmlinux
```

In gdb:

```
(gdb) lx-symbols
(gdb) target remote :1234
```

then you can play with gdb, see https://01.org/linuxgraphics/gfx-docs/drm/dev-tools/gdb-kernel-debugging.html for info on helper commands
like lx-symbols.

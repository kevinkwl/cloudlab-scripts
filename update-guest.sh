source config.sh

# copy modules
rsync -av ${MOD_PATH}/ root@${guest_ip}:/lib/modules/.

scp System.map root@${guest_ip}:~/.
scp arch/x86/boot/bzImage root@${guest_ip}:~/vmlinuz-${VERSION}
scp .config root@${guest_ip}:~/.

ssh root@${guest_ip} "installkernel ${VERSION} vmlinuz-${VERSION} System.map"
ssh root@${guest_ip} "update-grub"
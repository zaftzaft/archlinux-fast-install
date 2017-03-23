
pacman -S qemu

pacman -S libvirt
pacman -S virt-install

ebtables dnsmasq bridge-utils openbsd-netcat

systemctl start libvirtd
systemctl enable libvirtd


sudo virsh net-start default
sudo virsh net-autostart default




# virsh
sudo virsh console <>

sudo virsh shutdown <>

sudo virsh start <>


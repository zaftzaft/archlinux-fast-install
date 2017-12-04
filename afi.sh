#!/bin/bash
# Arch linux Fast Install script.

dev=/dev/sda

loadkeys jp106

echo fdisk
{
  echo o
  echo n
  echo p
  echo 1
  echo
  echo +100M
  echo a
  echo n
  echo
  echo
  echo
  echo
  echo w # Write changes
} | fdisk $dev

mkfs.ext4 ${dev}1
mkfs.ext4 ${dev}2

sync

echo mount
mount ${dev}2 /mnt
mkdir /mnt/boot
mount ${dev}1 /mnt/boot

echo pacstrap
echo "Server = http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

pacstrap /mnt base base-devel vim openssh grub
sync


genfstab -U /mnt > /mnt/etc/fstab
sync

echo chroot
{
  echo "echo en_US.UTF-8 UTF-8 >> /etc/locale.gen"
  echo "echo ja_JP.UTF-8 UTF-8 >> /etc/locale.gen"
  echo locale-gen
  echo "echo LANG=en_US.UTF-8 > /etc/locale.conf"
  echo "echo KEYMAP=jp106 > /etc/vconsole.conf"
  echo grub-install --recheck ${dev}
  echo grub-mkconfig -o /boot/grub/grub.cfg
  echo exit
} | arch-chroot /mnt /bin/bash


echo systemd-networkd
ip -o link | while read line
do
  t=`echo $line | sed -e "s/^[^:]\+: \([^:]\+\):.*/\1/"`
  if [ $t != "lo" ];then

    cat << EOS > /mnt/etc/systemd/network/${t}.network
[Match]
Name=${t}
[Network]
DHCP=ipv4
#Address=192.168.0.100/24
#Gateway=192.168.0.1
EOS

  fi
done




echo reboot and set passwd and hostname,etc.....

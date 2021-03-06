#!/bin/bash


systemctl start systemd-networkd
systemctl enable systemd-networkd

echo name_servers=8.8.8.8 >> /etc/resolvconf.conf
resolvconf -u

systemctl start sshd
systemctl enable sshd

timedatectl set-timezone Asia/Tokyo
timedatectl set-ntp true

echo NTP=ntp.nict.jp >> /etc/systemd/timesyncd.conf
systemctl restart systemd-timesyncd


cat << 'EOF' >> /etc/pacman.conf
[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
EOF



pacman -Syyu --noconfirm \
  yaourt downgrade pkgfile \
  tmux git wget htop unzip \
  tcpdump hping nmap bmon \
  nodejs npm python-pip \
  dosfstools ntfs-3g samba exfat-utils rsync squashfs-tools \
  whois traceroute iperf iperf3 iftop bmon \
  scapy3k openbsd-netcat \
  net-tools bind-tools ethtool net-snmp \
  mtr nethogs iptraf-ng bwm-ng \
  uucp wireshark-cli \
  jq arch-install-scripts \
  wpa_supplicant iw wireless_tools aircrack-ng rfkill \
  xf86-input-synaptics acpi lm_sensors



echo EXPORT=2 >> /etc/yaourtrc
pkgfile --update

#yaourt -S --noconfirm nkf


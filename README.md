# 超高速 Arch Linux インストール

## キーボード配列の設定

```
$ loadkeys jp106
```



## パーティションの設定

```
$ fdisk /dev/sda
```

```
1 boot +100M
2 /
```
+ boot flag をつける

```
:n
:
:+100M
:a
:n
:
:
:w
```


## フォーマット

```
$ mkfs.ext4 /dev/sda1
$ mkfs.ext4 /dev/sda2
```


## マウント

```
$ mount /dev/sda2 /mnt
$ mkdir /mnt/boot
$ mount /dev/sda1 /mnt/boot
```


## ミラーリストの設定

```
$ vim /etc/pacman.d/mirrorlist
```
+ .jp の早そうなやつを一番上に持ってくる


## パッケージのインストール
```
$ pacstrap /mnt base linux base-devel
$ pacstrap /mnt vi vim openssh
$ pacstrap /mnt openresolv
```

## fstab の設定
```
$ genfstab -U /mnt > /mnt/etc/fstab
```
+ noatime を追加
  - ただのメモ

## chroot
```
$ arch-chroot /mnt /bin/bash
```

## locale
```
$ vim /etc/locale.gen
```

```
# コメントアウトを外す
en_US.UTF-8
ja_JP.UTF-8
```

```
$ locale-gen
$ echo LANG=en_US.UTF-8 > /etc/locale.conf
```

## keymap
```
$ echo KEYMAP=jp106 > /etc/vconsole.conf
```



## hostname
```
$ echo host > /etc/hostname
```

- host は自分の好きな文字

## root password
```
$ passwd
```

## grub (boot loader)
```
$ pacman -S grub
$ grub-install --recheck /dev/sda
$ grub-mkconfig -o /boot/grub/grub.cfg
```

## user setting
```
$ useradd -m <username>
$ passwd <username>
```

## sudo setting
```
$ visudo
```

```
# 追加する
 <username> ALL=(ALL) ALL
```

- 下の方にある root ALL=(ALL) ALL をコピーして編集する

## reboot
```
$ exit
$ umount -R /mnt
$ shutdown -r now
```

------------------------
# インストール後の設定

# Network
```
$ export EDITOR=vim
$ sudoedit /etc/systemd/network/net.network
```

```
[Match]
Name=<nic>

# <nic> は enp0s33 などに置き換える
# :r! ip link で vim に コマンドの出力結果の貼付け

[Network]
DHCP=ipv4


# 以下はメモ
#Address=
#Gateway=
```

```
$ sudo systemctl enable systemd-networkd
$ sudo systemctl restart systemd-networkd
```

- メモ systemd-networkd のマニュアル
```
$ man systemd.network
```


## Resolv
```
$ sudoedit /etc/resolvconf.conf
```

```
name_servers=8.8.8.8
```

```
$ sudo resolvconf -u
```

## Ping
```
$ ping 8.8.8.8
```
```
$ ping google.com
```

## Wi-Fi
```
$ sudo pacman -S wpa_supplicant iw
```


# Software

## ssh
```
$ sudo pacman -S openssh
```

```
$ sudoedit /etc/ssh/sshd_config
```

```
PermitRootLogin no
```

```
$ sudo systemctl enable sshd
$ sudo systemctl start sshd
```


## systemd-timesyncd
```
$ sudo timedatectl set-timezone Asia/Tokyo
$ sudo timedatectl set-ntp true
```

-
```
/etc/systemd/timesyncd.conf

NTP=ntp.nict.jp

restart systemd-timesyncd
```

### ハードウェアクロック(ntp後)

```
$ hwclock -w --localtime
```




# yaourt => yay
wget https://github.com/Jguer/yay/releases/download/v9.0.1/yay_9.0.1_x86_64.tar.gz
tar xf
cp yay /usr/bin
yay -S yay

## pkg cache
find .cache/yay/ | grep pkg


# downgrade




## pkgfile

```
$ sudo pacman -S pkgfile
$ sudo pkgfile --update
```


# 必要に応じて

```
sudo pacman -S wget tmux git
sudo pacman -S xsel
sudo pacman -S htop bmon
sudo pacman -S go
sudo pacman -S nodejs npm unzip
sudo pacman -S python-pip

sudo pacman -S gdb
yaourt -S metasploit
```



## systemd-nspawn
```
mkdir /etc/systemd/system/systemd-nspawn@.service.d
/etc/systemd/system/systemd-nspawn@.service.d/override.conf
```
```
[Service]
ExecStart=
ExecStart=/usr/bin/systemd-nspawn --quiet --keep-unit --boot --link-journal=try-guest --machine=%i
```

### pacstrap
```
pacstrap -icd <dir> base base-devel --ignore linux
systemd-nspawn -D <dir>
(nspawn) echo pts/0 >> /etc/securetty
```




# Desktop ENV

## mate

```
$ sudo pacman -S xorg-server xorg-xinit
$ sudo pacman -S mate
$ sudo pacman -S mate-applets eom mozo mate-terminal
```


```
$ vim ~/.xinitrc

exec mate-session
```

### startx
```
$ startx
```

### disable desktop icons

```
dconf write /org/mate/caja/desktop/computer-icon-visible false
dconf write /org/mate/caja/desktop/home-icon-visible false
dconf write /org/mate/caja/desktop/trash-icon-visible false
```


### メニューバーアイコンの変更
```
$ gsettings get org.mate.panel.menubar icon-name
'start-here'

$ gsettings set org.mate.panel.menubar icon-name archlinux


```



## mate-terminal
```
$ pacman -S mate-terminal
```
- https://github.com/cledoux/mate-terminal-colors-solarized


## urxvt
```
$ pacman -S rxvt-unicode

yay -S urxvt-resize-font-git
```

## input method
```
pacman -S fcitx-im fcitx-mozc fcitx-configtool
```

```
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
```


## uim
pacman -S uim

```
sudoedit /etc/pacman.conf
```
```
[pnsft-pur]
SigLevel = Optional TrustAll
Server = http://downloads.sourceforge.net/project/pnsft-aur/pur/$arch
```

```
#pacman -Sy uim-mozc
#uim-module-manager --register mozc

yaourt -S uim-mozc
```


```
export GTK_IM_MODULE='uim'
export QT_IM_MODULE='uim'
uim-xim &
uim-toolbar-gtk-systray &
export XMODIFIERS='@im=uim'
```


+ ホットキーによる入力方式の~ 無効


## xmodmap
pacman -S xorg-xev


## Theme

```
pacman -S materia-gtk-theme
yay -S maia-icon-theme
```


## Font

```
$ pacman -S otf-ipafont
$ yay -S ttf-ricty
$ pacman -S adobe-source-code-pro-fonts
```

### emoji
```
#$ pacman -S ttf-symbola
$ pacman -S noto-fonts-emoji
```


## laptop

```
$ pacman -S xf86-input-synaptics acpi lm_sensors
```
```
sudo sensors-detect
```

## Audio
```
$ pacman  -S alsa-utils


alsactl store

systemctl status alsa-restore
```

## Chrome
```
$ yay -S google-chrome
```

## Android
```
$ sudo pacman -S android-tools
$ sudo pacman -S android-udev

```



## mikutter
```
yaourt -S mikutter
```


## VMWare
```
$ sudo mkdir /etc/init.d
$ sudo pacman -S linux-headers
$ yaourt -S vmware-systemd-services
```

## virtualbox
```
$ sudo pacman -S linux-headers
$ sudo pacman -S virtualbox
```

### virtuablbox USB
- usb extension pack のインストール
```
gpasswd -a <user> vboxusers
```


### VMWare console
```
$ yaourt ncurses5-compat-libs
```


## Wireshark
```
$ sudo pacman -S wireshark-qt
or
$ yay -S wireshark-gtk
```

```
$ sudo gpasswd -a <username> wireshark
$ newgrp wireshark
```

## シリアル接続 RS232C - USB
```
$ sudo pacman -S uucp
$ sudo gpasswd -a <username> uucp
```

### 接続
```
$ cu -l /dev/ttyUSB0
```

### 切断
```
~.
```


## リモートデスクトップ
```
$ sudo pacman -S remmina freerdp
```

## Media
```
asunder
brasero
vlc qt4
gimp
inkscape
rawtherapee
```

#### asunder http proxy
```
server: freedbtest.dyndns.org
port: 80
```

## fs
```
sudo pacman -S dosfstools ntfs-3g samba exfat-utils rsync
sudo pacman -S squashfs-tools
```

## network
```
sudo pacman -S tcpdump hping nmap
sudo pacman -S whois traceroute iperf iperf3 iftop bmon
# kamene (old scapy3k)
sudo pacman -S kamene openbsd-netcat
sudo pacman -S wireless_tools aircrack-ng rfkill
sudo pacman -S net-tools bind-tools ethtool net-snmp
sudo pacman -S mtr nethogs iptraf-ng bwm-ng
sudo pacman -S wol
sudo pacman -S bridge-utils
sudo pacman -S openvpn

sudo npm i -g wscat

```

### openvpn
```
groupadd -r nogroup
```

## Wireguard
```
pacman -S linux-headers wireguard-dkms wireguard-tools
```

## Wake On LAN
```
yay -S wol-systemd

systemctl start wol@eth0
systemctl enable wol@eth0
```

## util
```
pacman -S lsof
pacman -S jq
pacman -S arch-install-scripts
pacman -S maim slop
alias scr='maim -s ~/Desktop/$(date +%s).png'
pacman -S xsel scrot
pacman -S lshw

yay -S nkf
```

## Bluetooth
```
pacman -S bluez bluez-utils

systemctl start bluetooth
systemctl enable bluetooth
```


## Awesome network tool
```
git clone https://github.com/upa/deadman.git
```

## Prometheus
```
sudo pacman -S prometheus-node-exporter

systemctl start prometheus-node-exporter
systemctl enable prometheus-node-exporter
```


## Office
```
pacman -S thunderbird
pacman -S libreoffice-still
pacman -S slack-desktop
```


## matplotlib
```
pacman -S python-matplotlib python-pandas
pacman -S tk
```


# Truble Shoot


## Wi-Fi
```
$ wpa_passphrase <ssid> <password> > .config
```

### connect script
```
ip link set dev wlp3s0 up
pkill wpa_supplicant
wpa_supplicant -i wlp3s0 -c $1 -B
dhcpcd wlp3s0
```

### hide SSID(config)
```
network={
  ssid="hogehoge"
  psk=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

  scan_ssid=1
}
```



## Downgrade
+ yaourt の設定してから
```
$ pacman -S downgrade
$ downgrade <パッケージ>
```

## シャットダウンに時間がかかる

```
$ sudoedit /etc/systemd/system.conf
```

```
DefaultTimeoutStopSec=3s
```







# TODO

## .bashrc alias


## .vimrc


### dein
```
https://github.com/Shougo/dein.vim
```
```
$ curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
$ sh ./installer.sh ~/.vim/dein
```

```
:call dein#install()
```


## .tmux.conf

```
set-option -g status-position top
set-option -g status-right "#(acpi -b | sed -e 's/Battery 0://' -e 's/%.*//')\% %m/%d %H:%M:%S"
set -s escape-time 0

set-window-option -g window-status-format " #I: #W "
set-window-option -g window-status-current-format " #I: #W "


set -g prefix C-j
unbind C-b

bind v copy-mode
bind x split-window -h -c "#{pane_current_path}"
bind y split-window -v -c "#{pane_current_path}"
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R


set-option -g status-bg brightblack
set-option -g status-fg white

set-window-option -g window-status-fg white
set-window-option -g window-status-bg default

set-window-option -g window-status-current-fg brightblue
set-window-option -g window-status-current-bg black

set-option -g pane-border-fg black
set-option -g pane-active-border-fg blue

set-option -g message-bg black
set-option -g message-fg brightblue
```


## net

## urxvt .X


## br


## synaptics
### x220 synaptics
```
/etc/X11/xorg.conf.d
/usr/share/X11/xorg.conf.d/70-synaptics.conf (2016/12/08)
```

```
# X220
Section "InputClass"
  Identifier "no need for accelerometers in X"
  MatchProduct "SynPS/2 Synaptics TouchPad"
  Option "ClickPad" "true"
  # KAMI
  Option "TouchpadOff" "1"
  #Option "MaxSpeed" "0"
  #Option "ignore" "on"
EndSection
```



## cf-sx3 .asoundrc
```
pcm.!default {
  type hw
  card 1
}

```


# Broadcom BCM57788
```
modprobe -r tg3
modprobe tg3
```






# install UEFI
```
gdisk /dev/sda
:o
:n
:
:+200M
:EF00

:n
:
:
:
:w
```

```
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
```


```
pacman -S grub dosfstools efibootmgr



grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub --recheck

grub-mkconfig -o /boot/grub/grub.cfg
```


# samba
```
wget "https://git.samba.org/samba.git/?p=samba.git;a=blob_plain;f=examples/smb.conf.default;hb=HEAD" -O /etc/samba/smb.conf

pdbedit -a -u <samba_user>

systemctl start smb
systemctl enable smb
```

```
log file = /var/log/samba/%m.log
```





# arch ARM

vim /boot/config.txt
```
fsck.mode=force
dtparam=i2c_arm=on
```

vim /etc/modules-load.d/raspberrypi.conf
```
i2c-dev
i2c-bcm2708
```

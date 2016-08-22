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
$ pacstrap /mnt base base-devel
$ pacstrap /mnt vim
```

## fstab の設定
```
$ genfstab -U /mnt > /mnt/etc/fstab
```
+ noatime を追加

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

## reboot
```
$ exit
$ umount -R /mnt
$ shutdown -r now
```


# Network
```
$ sudoedit /etc/systemd/network/net.network
```

```
[Match]
Name=<nic>

[Network]
DHCP=ipv4
```

```
$ systemctl enable systemd-networkd
$ systemctl restart systemd-networkd
```

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
$ sudo resolveconf -u
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
$ systemctl enable sshd
$ systemctl start sshd
```


## timezone
```
$ sudo ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
```

## ntp
```
$ pacman -S openntpd
$ sudoedit /etc/ntpd.conf
```


```
  server 0.jp.pool.ntp.org
  server 1.jp.pool.ntp.org
  server 2.jp.pool.ntp.org
  server 3.jp.pool.ntp.org
```

```
$ systemctl enable openntpd
```

### ハードウェアクロック(ntp後)

```
$ hwclock -w --localtime
```





## yaourt

```
$ sudoedit /etc/pacman.conf
```

```
  [archlinuxfr]
  SigLevel = Never
  Server = http://repo.archlinux.fr/$arch
```

```
$ sudo pacman -Sy yaourt
$ sudo pamcan -S downgrade
```

## pkgfile

```
$ sudo pacman -S pkgfile
$ sudo pkgfile --update
```


# 必要に応じて

```
sudo pacman -S tmux git
sudo pacman -S xsel
sudo pacman -S wget
sudo pacman -S tcpdump hping nmap
sudo pacman -S htop bmon
sudo pacman -S nodejs npm unzip
sudo pacman -S gdb
yaourt -S metasploit
```





# Desktop ENV

## mate

```
$ pacman -S xorg-server xorg-xinit
$ pacman -S mate
$ pacman -S terminator
$ pacman -S mate-applets eom
```

```
$ vim ~/.xinitrc
  exec mate-session
```

### disable desktop icons

```
dconf write /org/mate/caja/desktop/computer-icon-visible false
dconf write /org/mate/caja/desktop/home-icon-visible false
dconf write /org/mate/caja/desktop/trash-icon-visible false
```

## urxvt
```
$ pacman -S rxvt-unicode
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
pacman -S uim-mozc
uim-module-manager --register mozc
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


## theme

```
$ yaourt -S vertex-themes
$ yaourt -S menda-maia-icon-theme
```


## font

```
$ yaourt -S otf-ipafont
$ yaourt -S ttf-ricty
```


## laptop

```
$ pacman -S xf86-input-synaptics
$ pacman -S acpi
$ pacman -S lm_sensors
```

### x220 synaptics
```
/etc/X11/xorg.conf.d
```


## Chrome
```
$ yaourt -S google-chrome
```


## VMWare
```
$ sudo mkdir /etc/init.d
$ sudo pacman -S linux-headers
$ yaourt -S vmware-systemd-services
```


### VMWare console
```
$ yaourt ncurses5-compat-libs
```


## Wireshark
```
$ sudo pacman -S wireshark-gtk
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




# Truble Shoot

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

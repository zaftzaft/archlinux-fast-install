# ソフトウェア未整理

## wine
### ない 20161109
pacman -S wine

## xrdp
### だめ 20161107
yaourt -S xrdp-git


## SMART
pacman -S smartctl

smartctl -a /dev/sda


## maim
pacman -S maim slop




## GNS3
yaourt -S gns3-server
yaourt -S gns3-gui
yaourt -S dynamips


## TFTP
pacman -S tftp-hpa

/srv/tftp
にファイルを入れる

systemctl start tftpd



## urxvt
yaourt -S urxvt-fullscreen

.Xresources
```
URxvt.perl-ext-common: fullscreen
URxvt.keysym.F11: perl:fullscreen:switch
```

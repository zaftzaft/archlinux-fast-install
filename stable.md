# Arch Linux 安定化メモ
`https://wiki.archlinuxjp.org/index.php/Arch_Linux_%E3%81%AE%E5%AE%89%E5%AE%9A%E5%8C%96`


## linux-lts
```
$ pacman -S linux-lts
$ grub-mkconfig -o /boot/grub/grub.cfg
```


## インストール済みパッケージのバックアップ
```
$ # バージョンあり
$ pacman -Qne > pkg-version.list
$ # バージョンなし
$ pacman -Qqne > pkg.list

$ # バックアップから再インストール
$ pacman -S --needed $(< pkg.list )

```

## 個人メモ



# for Raspberry pi

# install
https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-3

# add fsck
vi /boot/config.txt
```
fsck.mode=force
```


# time
timedatectl set-timezone Asia/Tokyo
timedatectl set-ntp true

vim /etc/systemd/timesyncd.conf
```
NTP=ntp.nict.jp
```


# i2c
- /boot/config.txt
```
dtparam=i2c_arm=on
```


- /etc/modules-load.d/raspberrypi.conf
```
i2c-dev
i2c-bcm2708
```

pacman -S i2c-tools




# HDMI off

/usr/lib/systemd/system/hdmi-power-off.service
```
[Unit]
Description=HDMI power off

[Service]
Type=oneshot
ExecStart=/opt/vc/bin/tvservice -o

[Install]
WantedBy=default.target
```

systemctl start hdmi-power-off
systemctl enable hdmi-power-off

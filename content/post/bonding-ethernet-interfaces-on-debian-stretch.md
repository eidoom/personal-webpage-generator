+++
title = "Bonding ethernet interfaces on Debian Stretch"
date = "2019-11-02T16:36:51Z"
tags = ["network", "linux", "server"]
categories = ["computing"]
+++

### Setting up multiple ethernet interfaces to work in parallel 

Enable systemd-networkd

`sudo systemctl enable systemd-networkd`

Configure bond device

`sudo vim /etc/systemd/network/bond1.netdev`

```
[NetDev]
Name=bond1
Description=LAG/Bond to a switch
Kind=bond

[Bond]
Mode=802.3ad
```

Add interfaces to bond

`sudo vim /etc/systemd/network/bond1.network`

```
[Match]
Name=enp*

[Network]
Bond=bond1
```

Assign IP to bond

`sudo vim /etc/systemd/network/dhcp.network`

```
[Match]
Name=bond1

[Network]
DHCP=yes
```

Disable previous configuration, e.g

`sudo mv /etc/network/interfaces /etc/network/interfaces.backup`

or

`sudo apt remove connman`

Apply with reboot

`sudo reboot`

Check

`ip a`

```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp3s0: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master bond1 state UP group default qlen 1000
    link/ether da:0e:cb:14:25:5d brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.116/24 brd 192.168.1.255 scope global enp3s0
       valid_lft forever preferred_lft forever
    inet6 fe80::d0bb:9cf3:3908:44c9/64 scope link tentative 
       valid_lft forever preferred_lft forever
3: enp0s31f6: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master bond1 state UP group default qlen 1000
    link/ether da:0e:cb:14:25:5d brd ff:ff:ff:ff:ff:ff
4: bond0: <NO-CARRIER,BROADCAST,MULTICAST,MASTER,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether 0e:bf:4a:31:39:58 brd ff:ff:ff:ff:ff:ff
5: bond1: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether da:0e:cb:14:25:5d brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.115/24 brd 192.168.1.255 scope global dynamic bond1
       valid_lft 84217sec preferred_lft 84217sec
```
Notice

|interface| UP   | SLAVE | MASTER | has IP address |
|---------|------|-------|--------|----------------|
|`bond1`  |  y   |    n  |  y     |   y            |
|`enp*`   |y|y|n|n|

[Reference](https://wiki.debian.org/Bonding#Using_systemd-networkd)

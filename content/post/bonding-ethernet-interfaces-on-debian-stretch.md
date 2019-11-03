+++
title = "Bonding ethernet interfaces on Debian Buster"
date = "2019-11-02T16:36:51Z"
tags = ["network", "linux", "server", "systemd", "debian"]
categories = ["computing"]
+++

I set up my linux server to use its two ethernet interfaces in [parallel](https://en.wikipedia.org/wiki/Link_aggregation#Link_Aggregation_Control_Protocol). My primary [reference was from the Debian wiki](https://wiki.debian.org/Bonding#Using_systemd-networkd).

#### Migrating to systemd-networkd

I used [systemd-networkd](https://wiki.archlinux.org/index.php/Systemd-networkd) to configure the bond interface. 
My system already uses [systemd](https://wiki.archlinux.org/index.php/Systemd), so I just had to enable systemd-networkd.

```shell
sudo systemctl enable systemd-networkd
```

I also set up [systemd-resolved](https://wiki.archlinux.org/index.php/Systemd-resolved) to [provide name resolution](https://wiki.archlinux.org/index.php/Systemd-resolved#DNS).

```shell
sudo systemctl enable systemd-resolved
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
```

Over the years, I have used various networking solutions on this machine. 
Most recently, I set up [connman](https://en.wikipedia.org/wiki/ConnMan) to [connect wirelessly to eduroam](https://wiki.archlinux.org/index.php/ConnMan#Connecting_to_eduroam_(802.1X)) at my previous residence. 
I disabled all previous configurations.

```
sudo mv /etc/network/interfaces /etc/network/interfaces.backup
sudo apt remove connman
sudo apt remove wpasupplicant
sudo systemctl disable dhcpcd
```

#### Configure bond device

The configuration files for systemd-networkd use [this syntax](https://wiki.archlinux.org/index.php/Systemd-networkd#Configuration_files).
First, I set up the new bond interface.

```
sudo vim /etc/systemd/network/10-bond1.netdev
```

```
[NetDev]
Name=bond1
Kind=bond

[Bond]
Mode=802.3ad
```

#### Add interfaces to bond

Then I slaved the ethernet interfaces to the bond.

```
sudo vim /etc/systemd/network/10-bond1.network
```

```
[Match]
Name=enp*

[Network]
Bond=bond1
```

#### Assign IP to bond

Finally, I assigned a static IP address to the bond interface.

```
sudo vim /etc/systemd/network/10-enp_.network
```

```
[Match]
Name=bond1

[Network]
BindCarrier=enp3s0 enp0s31f6
Address=192.168.1.2
Gateway=192.168.1.1
DNS=192.168.1.1
```

#### Apply and check

I applied the new configuration with a reboot

```
sudo reboot
```

Further applications of new test configurations (the above configuration being the final such iteration) were performed by restarting systemd-networkd

```shell
sudo systemctl restart systemd-networkd
```

Checking the network configuration,

```
ip a
```

```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp3s0: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master bond1 state UP group default qlen 1000
    link/ether da:0e:cb:14:25:5d brd ff:ff:ff:ff:ff:ff
3: enp0s31f6: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master bond1 state UP group default qlen 1000
    link/ether da:0e:cb:14:25:5d brd ff:ff:ff:ff:ff:ff
4: bond1: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether da:0e:cb:14:25:5d brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.2/24 brd 192.168.1.255 scope global bond1
       valid_lft forever preferred_lft forever
    inet6 fdaa:bbcc:ddee:0:d80e:cbff:fe14:255d/64 scope global dynamic mngtmpaddr noprefixroute 
       valid_lft 2006054619sec preferred_lft 2006054619sec
    inet6 fe80::d80e:cbff:fe14:255d/64 scope link 
       valid_lft forever preferred_lft forever
```
I was happy to see that

|interface| UP   | SLAVE | MASTER | has IP address |
|---------|------|-------|--------|----------------|
|bond1  |  y   |    n  |  y     |   y            |
|enp*   |y|y|n|n|

Also,

```shell
cat /proc/net/bonding/bond1
```

```
Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)

Bonding Mode: IEEE 802.3ad Dynamic link aggregation
Transmit Hash Policy: layer2 (0)
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0

802.3ad info
LACP rate: slow
Min links: 0
Aggregator selection policy (ad_select): stable

Slave Interface: enp0s31f6
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: d0:50:99:85:3c:b6
Slave queue ID: 0
Aggregator ID: 1
Actor Churn State: none
Partner Churn State: churned
Actor Churned Count: 0
Partner Churned Count: 1

Slave Interface: enp3s0
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: d0:50:99:85:3c:b8
Slave queue ID: 0
Aggregator ID: 2
Actor Churn State: churned
Partner Churn State: churned
Actor Churned Count: 1
Partner Churned Count: 1
```

confirmed that the bond was working.

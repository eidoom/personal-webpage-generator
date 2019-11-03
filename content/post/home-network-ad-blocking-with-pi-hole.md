+++
title = "Home network ad-blocking with Pi-hole"
date = "2019-11-03T12:41:53Z"
tags = ["network","linux","server"]
categories = ["computing"]
+++

[Pi-hole](https://pi-hole.net/) is an awesome piece of software which blocks ads across a network at the name resolution level. 
Check out the source [here](https://github.com/pi-hole/pi-hole).
I set it up on my home linux server.

I hoped into my git repos folder and cloned the Pi-hole repo

```
cd ~/git
git clone git@github.com:pi-hole/pi-hole.git
```

then used the installation scripts to install it on my system

```
cd ~/git/pi-hole/automated\ install
sudo ./basic-install.sh
```

I chose [CloudFlare](https://cloudflare-dns.com/dns/) as my Upstream DNS Provider because they have a good [privacy policy](https://wiki.archlinux.org/index.php/Alternative_DNS_services#Cloudflare) and came out on top for performance in my ping tests

```
ping -c 3 1.1.1.1
```

```
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=58 time=12.3 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=58 time=12.1 ms
64 bytes from 1.1.1.1: icmp_seq=3 ttl=58 time=12.2 ms

--- 1.1.1.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 5ms
rtt min/avg/max/mdev = 12.104/12.202/12.339/0.161 ms
```

versus runner-up [OpenDNS](https://www.opendns.com/)

```
ping -c 3 208.67.222.220
```

```
PING 208.67.222.220 (208.67.222.220) 56(84) bytes of data.
64 bytes from 208.67.222.220: icmp_seq=1 ttl=58 time=17.6 ms
64 bytes from 208.67.222.220: icmp_seq=2 ttl=58 time=18.2 ms
64 bytes from 208.67.222.220: icmp_seq=3 ttl=58 time=18.0 ms

--- 208.67.222.220 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 5ms
rtt min/avg/max/mdev = 17.602/17.933/18.177/0.287 ms
```

I gave Pi-hole the static IP address of my server and set it to listen on my server's [bonded ethernet interface](../bonding-ethernet-interfaces-on-debian-stretch/).
I used the default blocklists.

That's it for Pi-hole itself - super easy!
The only thing left to do was to tell my router to use Pi-hole as its DNS.
Enduring the TalkTalk router web interface, I set the primary DNS server to the static IP address of my server (running Pi-hole) and left the secondary blank since I wanted Pi-hole to be the only DNS server.
This is discussed [here](https://discourse.pi-hole.net/t/how-do-i-configure-my-devices-to-use-pi-hole-as-their-dns-server/245).

Job done! 
To get devices on my local network using the new DNS server, I just restarted them.
Now I can enjoy data about blocked queries on the Pi-hole web interface at `http://HOSTNAME/admin` where HOSTNAME is the hostname of my server. 

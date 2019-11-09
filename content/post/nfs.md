+++
title = "File sharing with NFS"
date = "2019-11-09T17:53:14Z"
tags = ["server","desktop","linux","installation"]
categories = ["computing"]
description = "Setting up NFSv4 on my home server to share files on the LAN"
+++

## Introduction

I set up an NFSv4 server on my home server to share files with my desktop.
The server runs Debian Buster and the desktop runs Fedora 31.
My main resource was from the [Debian wiki](https://wiki.debian.org/NFSServerSetup).

## Server

Install the NFS server

```
sudo apt install nfs-kernel-server
```

To configure for version 4 only, we need to edit a couple of files:

```
sudo vim /etc/default/nfs-common
```
```
...
NEED_STATD="no"
...
NEED_IDMAPD="yes"
...
```

```
sudo vim /etc/default/nfs-kernel-server
```
```
...
RPCNFSDOPTS="-N 2 -N 3"
...
RPCMOUNTDOPTS="--manage-gids -N 2 -N 3"
...
```

and we can mask rpcbind

```
sudo systemctl mask rpcbind.service
sudo systemctl mask rpcbind.socket
```

Set up the files to be shared.
For example, to share USER's home directory to clients with addresses 192.168.1.*

```
echo 'echo "/home/USER 192.168.1.0/255.255.255.0(rw)" >> /etc/exports' | sudo sh
sudo systemctl restart nfs-server
```

## Client

Install the NFS client

```
sudo dnf install nfs-utils
```

Mount the share (for server with hostname HOSTNAME)

```
sudo mount HOSTNAME:/home/USER ~/mnt
```

Done.

## Performance

I tested the speed of my new network share following [this](https://serverfault.com/questions/324438/measure-benchmark-the-speed-latency-of-file-access-on-a-mounted-nfs-share).
The machines are connected by a gigabit ethernet connection.
First, measure the speed of copying a file from the client to the server

```
time dd if=/dev/zero of=~/mnt/testfile bs=16k count=128k
```
```
131072+0 records in
131072+0 records out
2147483648 bytes (2.1 GB, 2.0 GiB) copied, 29.9249 s, 71.8 MB/s
dd if=/dev/zero of=testfile bs=16k count=128k  0.10s user 1.38s system 4% cpu 29.933 total
```
and again
```
131072+0 records in
131072+0 records out
2147483648 bytes (2.1 GB, 2.0 GiB) copied, 31.6195 s, 67.9 MB/s
dd if=/dev/zero of=testfile bs=16k count=128k  0.12s user 1.33s system 4% cpu 31.774 total
```

Then measure the speed of copying a file from the server to the client

```
time dd if=~/mnt/testfile of=/dev/null bs=16k
```
```
73020+0 records in
73020+0 records out
1196359680 bytes (1.2 GB, 1.1 GiB) copied, 12.3081 s, 97.2 MB/s
dd if=testfile of=/dev/null bs=16k  0.13s user 0.81s system 7% cpu 12.311 total
```
and again
```
131072+0 records in
131072+0 records out
2147483648 bytes (2.1 GB, 2.0 GiB) copied, 22.2579 s, 96.5 MB/s
dd if=testfile of=/dev/null bs=16k  0.26s user 1.64s system 8% cpu 22.259 total
```

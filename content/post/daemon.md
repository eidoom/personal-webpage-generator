+++
title = "Autostarting services with systemd"
date = "2019-12-02T16:23:53Z"
tags = ["linux","server","systemd"]
categories = ["computing"]
description = "Using systemd to start custom service daemons on system start"
+++

## Introduction

There are sufficiently many services running on my home server now that starting them all manually after I restart the machine has become tedious, as infrequently as it occurs. 
Systemd can be used to automate this.

## Case study

One such service is [`beets web`](../nerdifying-music-library-management-with-beets).
To make it run on system start-up, simply create a `.service` file in `/etc/systemd/system/`

```shell
$ sudo vim /etc/systemd/system/beetsweb.service
```

```
[Unit]
Description=Beets web daemon
After=network.target

[Service]
User=ryan
Group=ryan

ExecStart=python3 -m beets web

Type=simple
TimeoutStopSec=20
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

To check that it works, manually start the daemon with

```shell
sudo systemctl start beetsweb
```

If the `.service` file needs changing, the configuration should be reloaded with

```shell
sudo systemctl start beetsweb
```

Once it's ready to use, activate running on startup with

```shell
sudo systemctl enable beetsweb
```


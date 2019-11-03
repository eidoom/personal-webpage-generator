+++
title = "Addressing the Transmission web client by hostname"
date = "2019-11-03T09:41:46Z"
tags = ["linux","bittorrent","server"]
categories = ["computing"]
+++

I have [Transmission](https://wiki.archlinux.org/index.php/Transmission) running on my linux server for BitTorrent transfers. 
I have been accessing the web interface using the IP address of the server in the URL like a dirty animal.
It's time to use the hostname of my server for this.

Before making any changes to the settings, Transmission has to be stopped otherwise it will overwrite those changes.

```
sudo systemctl stop transmission-daemon
```

Open the settings for editing

```
vim ~/.config/transmission-daemon/settings.json
```

Make sure rpc-host-whitelist-enabled is true and add the hostname of the server to rpc-host-whitelist.

Start up Transmission again

```
sudo systemctl start transmission-daemon
```

Enjoy.
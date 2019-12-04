+++
title = "Mpd"
date = "2019-12-04T19:14:46Z"
tags = [""]
categories = [""]
description = ""
draft = true
+++

# beets + MPD

## [BPD](https://beets.readthedocs.io/en/stable/plugins/bpd.html)

Open up the `beets` configuration with `beet config -e` and append `bpd` to `plugins:`.
Start BPD with `beet bpd`

## [ympd](https://github.com/notandy/ympd)

```sh
cd git
git clone git@github.com:notandy/ympd.git
cd ympd
sudo apt install libmpdclient2 libmpdclient-dev openssl cmake
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX:PATH=/usr
make -j
sudo make install
ympd -w 8090
```

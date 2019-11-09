+++
title = "Nerdifying music library management with beets"
date = "2019-11-03T13:50:54Z"
tags = ["linux","server","media","installation"]
categories = ["computing"]
description = "My favourite music library management software"
+++

[beets](http://beets.io/) is the endgame music library management system for me. 
I set it up on my linux server (running Debian Buster).

## Installation

I like living on the bleeding-edge (despite my stability policy on my server) and intended to tinker with the code, so I installed beets from the [GitHub repo](https://github.com/beetbox/beets) as an editable [pip](https://pypi.org/project/pip/) package as described [here](https://github.com/beetbox/beets/wiki/Hacking#getting-the-source).

```shell
cd ~/git
git clone git@github.com:beetbox/beets.git
cd ~/git/beets
python3 -m pip install --user -e .
```

I made an alias `beet` for quick terminal access

```shell
echo "alias beet='python3 -m beets'" >> ~/.zshrc
source ~/.zshrc
```

That was it for installation.

## Plugins

The next exciting part was the plugin feature.
There are some great plugins available, for example the [web plugin](https://beets.readthedocs.io/en/stable/plugins/web.html) which I've been using to play music from my music library. 

I installed most dependancies with `apt`. One exception was python packages that weren't packaged for Debian, which I just installed with pip

```
python3 -m pip install --user PACKAGE
```

Another was the [Chromaprint](https://acoustid.org/chromaprint) binary package required for the [Chromaprint/Acoustid Plugin](https://beets.readthedocs.io/en/stable/plugins/chroma.html).
I downloaded the [latest binary](https://github.com/acoustid/chromaprint/releases/download/v1.4.3/chromaprint-fpcalc-1.4.3-linux-x86_64.tar.gz), unarchived it and put `fpcalc` in `/usr/local/bin`.

```shell
cd ~/downloads
wget https://github.com/acoustid/chromaprint/releases/download/v1.4.3/chromaprint-fpcalc-1.4.3-linux-x86_64.tar.gz
tar -xvf chromaprint-fpcalc-1.4.3-linux-x86_64.tar.gz
sudo cp chromaprint-fpcalc-1.4.3-linux-x86_64/fpcalc /usr/local/bin
rm -r chromaprint-fpcalc-1.4.3-linux-x86_64*
```

## Configuration

Configuration was easy thanks to some great [docs](https://beets.readthedocs.io/en/stable/).
The configuration file is accessed via

```shell
beet config -e
```



+++
title = "A dashboard for my home server"
date = "2019-12-02T14:51:04Z"
tags = ["linux","server","web"]
categories = ["computing"]
description = "Using Nginx to serve a webpage with links to services on my home server."
+++

I have [a few services running on my home server](../../tags/server), so I set up a simple web page with links to each service.
To generate (static) content, I decided to use [pandoc](https://pandoc.org/) to generate html from a Markdown file.
I used [Nginx](https://nginx.org/) to serve the web page.

## Installing Nginx and pandoc

Simple! Since we're on Debian

```shell
$ sudo apt install nginx pandoc net-tools
```

I included `net-tools` for diagnostics. 

## Setting a custom port for Nginx

Since [Pi-hole was running on this machine](../home-network-ad-blocking-with-pi-hole/), I had to change the port that Nginx would use.
Choosing a memorable number, I decided to set the port to be `24601`.

Open up the settings file

```shell
$ sudo vim /etc/nginx/sites-enabled/default
```

and change

```shell
listen 80 default_server;
listen [::]:80 default_server;
```

to

```shell
listen 24601 default_server;
listen [::]:24601 default_server;
```

Then

```shell
$ sudo systemctl restart nginx
```

and confirm success with 

```shell
$ sudo netstat -tlpn | grep nginx
```
```shell
tcp        0      0 0.0.0.0:24601           0.0.0.0:*               LISTEN      5377/nginx: master  
tcp6       0      0 :::24601                :::*                    LISTEN      5377/nginx: master  
```

## Serving static content

I decided to keep the content in my home directory.

```shell
mkdir ~/www
```

To tell Nginx this, open 

```shell
$ sudo vim /etc/nginx/sites-enabled/default
```

and change

```shell
root /var/www/html;
```

to

```shell
root /home/USER/www;
```

then

```shell
$ sudo systemctl restart nginx
```

## Generating static content

Write the content in Markdown

```
cd ~/www
vim index.html
```

I lazily styled it with the css from a pandoc example

```
wget https://pandoc.org/demo/pandoc.css
```

I wrote a short Makefile for the generation step

```
echo "all:\n\tpandoc index.md -f markdown -t html5 -s --highlight-style haddock -c pandoc.css -o index.html" > Makefile
```

Generate the html with `make` and access the dashboard at `http://ryanserver:24601/`.


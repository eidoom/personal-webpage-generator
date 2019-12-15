+++
title = "MPD"
date = "2019-12-04T19:14:46Z"
tags = [""]
categories = [""]
description = ""
draft = true
+++

## [BPD](https://beets.readthedocs.io/en/stable/plugins/bpd.html)

Open up the `beets` configuration with `beet config -e` and append `bpd` to `plugins:`.
Start BPD with `beet bpd`.

<!--
This was rubbish
## [ympd](https://github.com/notandy/ympd)

```sh
cd git
git clone -b master git@github.com:notandy/ympd.git
cd ympd
sudo apt install libmpdclient2 libmpdclient-dev openssl cmake
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX:PATH=/usr
make -j
sudo make install
ympd -w 8090
```
-->

<!--
Couldn't get working
## [Ampache](https://github.com/ampache/ampache)

[prerequisites](https://github.com/ampache/ampache/blob/develop/README.md#requirements)

```sh
sudo apt update
sudo apt install apache2 php php-common php-json php-simplexml php-curl php-fpm php-mysql php-gd mariadb-server composer
git clone -b master git@github.com:ampache/ampache.git ~/ampache
chown ryan:www-data ~/ampache
cd ~/ampache
composer install --prefer-source --no-interaction
sudo mkdir /var/log/ampache
chmod g+w ~/ampache/config
```

### MariaDB

Configure database

```sh
sudo mysql_secure_installation
```

Choosing default options.

Set up new user.

```sh
$ sudo mysql
```

```sh
MariaDB [(none)]> GRANT ALL ON *.* TO 'wusername'@'localhost' IDENTIFIED BY 'password' WITH GRANT OPTION;
MariaDB [(none)]> FLUSH PRIVILEGES;
```

### Apache

```sh
sudo vi /etc/apache2/ports.conf
```

```sh
...
Listen 8090
...
```

```sh
$ sudo vim /etc/apache2/sites-available/ampache.conf
```

```sh
<VirtualHost *:8090>
    ServerAdmin ryanmoodie@gmail.com
    DocumentRoot /home/ryan/ampache
    ServerName ryanserver
    <Directory /home/ryan/ampache>
           Allowoverride all
    </Directory>
    ErrorLog ${APACHE_LOG_DIR}/ampache-error.log
    CustomLog ${APACHE_LOG_DIR}/ampache_access.log combined
</VirtualHost>
```

```sh
sudo a2dissite 000-default
sudo a2ensite ampache
sudo a2enmod rewrite
cp ~/ampache/rest/.htaccess.dist ~/ampache/rest/.htaccess
cp ~/ampache/play/.htaccess.dist ~/ampache/play/.htaccess
cp ~/ampache/channel/.htaccess.dist ~/ampache/channel/.htaccess
```

Test

```sh
sudo apachectl configtest
```

```sh
sudo systemctl start apache2
```

Disable

```sh
sudo a2dissite ampache
sudo systemctl reload apache2
```

### Nginx

[config](https://github.com/ampache/ampache/wiki/Installation#nginx)

```sh
$ sudo vi /etc/nginx/sites-available/ampache
```

```sh
server {

    # listen to
    listen  [::]:8090; #ssl; ipv6 optional with ssl enabled
    listen       8090; #ssl; ipv4 optional with ssl enabled

    server_name _;
    charset utf-8;

    # Logging, error_log mode [notice] is necessary for rewrite_log on,
    # (very usefull if rewrite rules do not work as expected)

         error_log       /var/log/ampache/error.log; # notice;
       # access_log      /var/log/ampache/access.log;
       # rewrite_log     on;

    # Use secure SSL/TLS settings, see https://mozilla.github.io/server-side-tls/ssl-config-generator/
    # ssl_protocols TLSv1.2;
    # ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-E    CDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256';
    # ssl_prefer_server_ciphers on;
    # add_header Strict-Transport-Security max-age=15768000;
    # etc.

    # Use secure headers to avoid XSS and many other things
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Robots-Tag none;
    add_header X-Download-Options noopen;
    add_header X-Permitted-Cross-Domain-Policies none;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header Referrer-Policy "no-referrer";
    add_header Content-Security-Policy "script-src 'self' 'unsafe-inline' 'unsafe-eval'; frame-src 'self'; object-src 'self'";

    # Avoid information leak
    server_tokens off;
    fastcgi_hide_header X-Powered-By;

    root /home/ryan/ampache;
    index index.php;

    # Somebody said this helps, in my setup it doesn't prevent temporary saving in files
    proxy_max_temp_file_size 0;

    # Rewrite rule for Subsonic backend
    if ( !-d $request_filename ) {
        rewrite ^/rest/(.*).view$ /rest/index.php?action=$1 last;
        rewrite ^/rest/fake/(.+)$ /play/$1 last;
    }

    # Rewrite rule for Channels
    if (!-d $request_filename){
      rewrite ^/channel/([0-9]+)/(.*)$ /channel/index.php?channel=$1&target=$2 last;
    }

    # Beautiful URL Rewriting
        rewrite ^/play/ssid/(\w+)/type/(\w+)/oid/([0-9]+)/uid/([0-9]+)/name/(.*)$ /play/index.php?ssid=$1&type=$2&oid=$3&uid=$4&name=$5 last;
        rewrite ^/play/ssid/(\w+)/type/(\w+)/oid/([0-9]+)/uid/([0-9]+)/client/(.*)/noscrobble/([0-1])/name/(.*)$ /play/index.php?ssid=$1&type=$2&oid=$3&uid=$4&client=$5&noscrobble=$6&name=$7 last;
        rewrite ^/play/ssid/(.*)/type/(.*)/oid/([0-9]+)/uid/([0-9]+)/client/(.*)/noscrobble/([0-1])/player/(.*)/name/(.*)$ /play/index.php?ssid=$1&type=$2&oid=$3&uid=$4&client=$5&noscrobble=$6&player=$7&name=$8 last;
        rewrite ^/play/ssid/(.*)/type/(.*)/oid/([0-9]+)/uid/([0-9]+)/client/(.*)/noscrobble/([0-1])/bitrate/([0-9]+)/player/(.*)/name/(.*)$ /play/index.php?ssid=$1&type=$2&oid=$3&uid=$4&client=$5&noscrobble=$6&bitrate=$7player=$8&name=$9 last;
        rewrite ^/play/ssid/(.*)/type/(.*)/oid/([0-9]+)/uid/([0-9]+)/client/(.*)/noscrobble/([0-1])/transcode_to/(w+)/bitrate/([0-9]+)/player/(.*)/name/(.*)$ /play/index.php?ssid=$1&type=$2&oid=$3&uid=$4&client=$5&noscrobble=$6&transcode_to=$7&bitrate=$8&player=$9&name=$10 last;

    # the following line was needed for me to get downloads of single songs to work
        rewrite ^/play/ssid/(.*)/type/(.*)/oid/([0-9]+)/uid/([0-9]+)/action/(.*)/name/(.*)$ /play/index.php?ssid=$1&type=$2&oid=$3&uid=$4action=$5&name=$6 last;
        location /play {
                if (!-e $request_filename) {
                rewrite ^/play/art/([^/]+)/([^/]+)/([0-9]+)/thumb([0-9]*)\.([a-z]+)$ /image.php?object_type=$2&object_id=$3&auth=$1 last;
                }

        rewrite ^/([^/]+)/([^/]+)(/.*)?$ /play/$3?$1=$2;
        rewrite ^/(/[^/]+|[^/]+/|/?)$ /play/index.php last;
        break;
        }

   location /rest {
      limit_except GET POST {
         deny all;
      }
   }

   location ^~ /bin/ {
      deny all;
      return 403;
   }

   location ^~ /config/ {
      deny all;
      return 403;
   }

   location / {
      limit_except GET POST HEAD{
         deny all;
      }
   }

   location ~ ^/.*.php {
        fastcgi_index index.php;

    # sets the timeout for requests in [s] , 60s are normally enough
        fastcgi_read_timeout 60s;

        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;

    # Mitigate HTTPOXY https://httpoxy.org/
        fastcgi_param HTTP_PROXY "";

    # has to be set to on if encryption (https) is used:
        # fastcgi_param HTTPS on;

        fastcgi_split_path_info ^(.+?\.php)(/.*)$;

    # chose as your php-fpm is configured to listen on
        # fastcgi_pass unix:/var/run/php-fpm.sock;
	fastcgi_pass unix:/run/php/php7.3-fpm.sock;
        # fastcgi_pass 127.0.0.1:8000/;
   }

   # Rewrite rule for WebSocket
   location /ws {
        rewrite ^/ws/(.*) /$1 break;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_pass http://127.0.0.1:8090/;
   }
}
```

Enable

```sh
sudo ln -s /etc/nginx/sites-available/ampache /etc/nginx/sites-enabled/
sudo systemctl restart nginx
```

Disable

```sh
sudo rm /etc/nginx/sites-enabled/ampache
sudo systemctl restart nginx
```

### Web installer http://ryanserver:8090/
-->
<!--
Alternative installation
```sh
wget https://github.com/ampache/ampache/releases/download/4.0.4/ampache-4.0.4_all.zip
unarchive ~/ampache-4.0.4_all.zip
rm -f ~/ampache-4.0.4_all.zip
mv ~/ampache-4.0.4_all ~/ampache
```
-->
<!--
This didn't work
```sh
sudo vi /etc/php/7.3/fpm/php.ini
```

```sh
...
upload_max_filesize = 20M
...
```
-->

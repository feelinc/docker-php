# docker-php
Dockerized PHP. Currently using **7.0.12-fpm** version. You can change to whatever you want inside the **Dockerfile**.

## Build

    $ chmod +x ./build.sh
    $ ./build.sh

## Prepare
- A folder where all container configuration data stored, in example "**php-container**".
- "**php-container/cron.d**" folder to provide cron configuration.
- "**php-container/conf.d**" folder to provide additional configuration, in example the **site.ini** and **site.pool.conf**.
- "**php-container/www**" folder to provide site files. You can put multiple sites here, just create a subfolder for each site. Make sure your webserver site root configuration having correct value based on this path "**/var/www/...**".

Create "**php-container/conf.d/site.ini**" file and put below content.

    date.timezone = Asia/Jakarta
    display_errors = On
    log_errors = On
    expose_php = Off
    error_log = /var/log/php/error.log
    
Create "**php-container/conf.d/site.pool.conf**" file and put below content.

    ; Unix user/group of processes
    ; Note: The user is mandatory. If the group is not set, the default user's group
    ;       will be used.
    user = www-data
    group = www-data

    ; The address on which to accept FastCGI requests.
    ; Valid syntaxes are:
    ;   'ip.add.re.ss:port'    - to listen on a TCP socket to a specific address on
    ;                            a specific port;
    ;   'port'                 - to listen on a TCP socket to all addresses on a
    ;                            specific port;
    ;   '/path/to/unix/socket' - to listen on a unix socket.
    ; Note: This value is mandatory.
    listen = 0.0.0.0:9000

## Run

"**--volumes-from**" option below required, if some of the site hosts is going to use a PHP container in the same host.

    docker run --interactive --tty --name=php --memory=1024m \
        --hostname=php \
        --volume=/path/to/php-container/cron.d:/etc/cron.d \
        --volume=/path/to/php-container/logs/cron:/var/log/cron \
        --volume=/path/to/php-container/logs/php:/var/log/php \
        --volume=/path/to/php-container/conf.d:/conf.d \
        --volume=/path/to/php-container/www:/var/www \
        --publish="9000:9000" \
        --detach \
        php:7.0.12-fpm
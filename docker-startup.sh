#!/bin/bash

cp /conf.d/* /usr/local/etc/php/conf.d

chmod 600 /etc/cron.d/*
chown -R www-data:www-data /var/www/.*

rsyslogd & cron -L15 & php-fpm
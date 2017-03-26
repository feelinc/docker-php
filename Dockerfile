FROM php:7.0.12-fpm

MAINTAINER Sulaeman <me@sulaeman.com>

RUN apt-get update \
  && apt-get install -y \
    rsyslog \
    cron \
    libcurl4-gnutls-dev \
    libpq-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libxslt1-dev

# Install Composer and make it available in the PATH
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# Install extensions using the helper script provided by the base image
RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini

RUN docker-php-ext-install \
  curl \
  gd \
  intl \
  mbstring \
  mcrypt \
  pdo_mysql \
  simplexml \
  xsl \
  zip \
  xml \
  xsl \
  soap \
  json \
  iconv

COPY docker-startup.sh /docker-startup.sh
RUN chmod +x /docker-startup.sh

RUN usermod -u 1000 www-data

WORKDIR /var/www

EXPOSE 9000

CMD ["sh", "/docker-startup.sh"]

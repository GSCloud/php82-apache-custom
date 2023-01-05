FROM php:8.2-apache
ARG DEBIAN_FRONTEND=noninteractive
ARG LC_ALL=en_US.UTF-8
ARG TERM=linux
ENV TERM=xterm LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN curl -sL https://getcomposer.org/installer | php -- --install-dir /usr/bin --filename composer
RUN a2enmod rewrite expires headers \
    && apt-get update \
    && apt-get upgrade \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get -y install --no-install-recommends git sudo \
        sqlite3 \
        libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
        libmagickwand-dev ghostscript \
        libicu-dev \
        libzip-dev zip unzip \
        libpq-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \    
    && docker-php-ext-install -j$(nproc) gd pdo_mysql pgsql pdo_pgsql bcmath intl opcache zip \
    && git clone https://github.com/Imagick/imagick /tmp/imagick \
    && cd /tmp/imagick \
    && phpize && ./configure \
    && make && make install \
    && rm -rf /tmp/imagick \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install sockets \
    && apt-get purge -y \
        libmagickwand-dev \
        libicu-dev \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
RUN pecl install redis && pecl install && docker-php-ext-enable redis

WORKDIR "/var/www"
EXPOSE 80

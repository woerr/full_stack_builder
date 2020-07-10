FROM php:7.3.19-cli-alpine3.12

RUN apk add --no-cache \
    freetype \
    libpng \
    libjpeg-turbo \
    freetype-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    icu-dev \
    libzip-dev \
    imagemagick \
    imagemagick-dev \
    msmtp \
    pcre-dev ${PHPIZE_DEPS} \
    openssl-dev \
    git \
    openssh \
    supervisor

RUN touch /var/log/msmtp.log && chown www-data: /var/log/msmtp.log

RUN docker-php-ext-install gd

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN docker-php-ext-install \
    mysqli \
    opcache \
    pdo \
    pdo_mysql \
    intl \
    zip \
    bcmath \
    pcntl \
    mbstring

RUN pecl install imagick && docker-php-ext-enable imagick
RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN pecl install mongodb && docker-php-ext-enable mongodb
RUN pecl install redis && docker-php-ext-enable redis

RUN docker-php-ext-install sockets && \
    docker-php-ext-enable sockets

#install ssh2 
# RUN cd /tmp \
#     && git clone https://git.php.net/repository/pecl/networking/ssh2.git \
#     && cd /tmp/ssh2/ \
#     && .travis/build.sh \
#     && docker-php-ext-enable ssh2 

RUN sed -i "s|pm.max_children =.*|pm.max_children = 80|" /usr/local/etc/php-fpm.d/www.conf && \
    sed -i "s|pm.start_servers =.*|pm.start_servers = 15|" /usr/local/etc/php-fpm.d/www.conf && \
    sed -i "s|^listen\s+.*|listen /var/run/fpm.sock|" /usr/local/etc/php-fpm.d/www.conf && \
    sed -i "s|pm.min_spare_servers =.*|pm.min_spare_servers = 10|" /usr/local/etc/php-fpm.d/www.conf && \
    sed -i "s|pm.max_spare_servers =.*|pm.max_spare_servers = 40|" /usr/local/etc/php-fpm.d/www.conf 

RUN ln -sf /usr/bin/msmtp /usr/sbin/sendmail

ENV PHP_INI_SCAN_DIR=/usr/local/etc/php/conf.d:/usr/local/etc/php/conf.d/addict.conf

COPY config/php.ini /usr/local/etc/php/php.ini
COPY config/addict.conf /usr/local/etc/php/conf.d/addict.conf
COPY config/supervisord.conf /etc/supervisor/supervisord.conf
COPY config/mailConfig /etc/msmtprc

COPY entrypoint.sh /entrypoint.sh

RUN chmod 755 /entrypoint.sh

CMD  "/entrypoint.sh"

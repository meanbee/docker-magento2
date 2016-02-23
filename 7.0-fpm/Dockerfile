#
# FPM, PHP 7.0, Magento 2 compatible container.
#
# Credit to Mark Shust <mark.shust@mageinferno.com> for the basis of this
# Dockerfile in the https://github.com/mageinferno/docker-magento2-php project.
#

FROM php:7.0-fpm

MAINTAINER Nick Jones <nick@nicksays.co.uk>

# Install dependencies
RUN apt-get update \
  && apt-get install -y \
    cron \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libxslt1-dev

# Configure the gd library
RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install required PHP extensions
RUN docker-php-ext-install \
  gd \
  intl \
  mbstring \
  mcrypt \
  pdo_mysql \
  xsl \
  zip

# Install the 2.4 version of xdebug that's compatible with php7
RUN pecl install -o -f xdebug-2.4.0RC4

VOLUME /root/.composer/cache

ADD bin/docker-environment /usr/local/bin/
ADD etc/php.ini /usr/local/etc/php/conf.d/zz-magento.ini
ADD etc/php-xdebug.ini /usr/local/etc/php/conf.d/zz-xdebug-settings.ini
ADD etc/php-fpm.conf /usr/local/etc/

ENV PHP_MEMORY_LIMIT 2G
ENV PHP_ENABLE_XDEBUG false
ENV MAGENTO_ROOT /magento
ENV MAGENTO_RUN_MODE developer
ENV DEBUG false
ENV UPDATE_UID_GID false

ENTRYPOINT ["/usr/local/bin/docker-environment"]
CMD ["php-fpm", "-F"]

#
# {{generated_by_builder}}
#

FROM <?php printf("php:%s-%s\n", $version, $flavour) ?>

MAINTAINER Nick Jones <nick@nicksays.co.uk>
<?php
    $packages = array_merge([
        'libfreetype6-dev',
        'libicu-dev',
        'libjpeg62-turbo-dev',
        'libmcrypt-dev',
        'libpng12-dev',
        'libxslt1-dev',
        'sendmail-bin',
        'sendmail',
        'sudo'
    ], $imageSpecificPackages ?? [])
?>

# Install dependencies
RUN apt-get update \
  && apt-get install -y \
    <?php echo join(" \\ \n    ", $packages) ?>


# Configure the gd library
RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install required PHP extensions
RUN docker-php-ext-install \
  dom \
  gd \
  intl \
  mbstring \
  mcrypt \
  pdo_mysql \
  xsl \
  zip \
  soap

# Install the 2.4 version of xdebug that's compatible with php7
RUN pecl install -o -f xdebug-2.4.0

# Install IonCube loader
ENV ION_CUBE_PHP_VERSION "<?php echo $version ?>"

RUN PHP_EXTENSION_DIR="$(php-config --extension-dir)" \
    && curl http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz -o /ioncube_loaders.tar.gz \
    && tar -zxvf /ioncube_loaders.tar.gz -C / \
    && cp "/ioncube/ioncube_loader_lin_${ION_CUBE_PHP_VERSION}.so" ${PHP_EXTENSION_DIR} \
    && echo "zend_extension=${PHP_EXTENSION_DIR}/ioncube_loader_lin_${ION_CUBE_PHP_VERSION}.so" > /usr/local/etc/php/conf.d/00-ioncube.ini \
    && rm -rf /ioncube /ioncube_loaders_lin_x86-64.tar.gz

ENV PHP_MEMORY_LIMIT 2G
ENV PHP_ENABLE_XDEBUG false
ENV PHP_ENABLE_IONCUBE false
ENV MAGENTO_ROOT /var/www/magento

ENV DEBUG false
ENV UPDATE_UID_GID false

ADD etc/php-xdebug.ini /usr/local/etc/php/conf.d/zz-xdebug-settings.ini
ADD etc/mail.ini /usr/local/etc/php/conf.d/zz-mail.ini

ADD docker-entrypoint.sh /docker-entrypoint.sh

RUN ["chmod", "+x", "/docker-entrypoint.sh"]

ENTRYPOINT ["/docker-entrypoint.sh"]

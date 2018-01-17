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
        'libpng-dev',
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
<?php $phpExtensions = array_merge([
  'dom',
  'gd',
  'intl',
  'mbstring',
  'pdo_mysql',
  'xsl',
  'zip',
  'soap',
  'bcmath'
], $imageSpecificPhpExtensions ?? []);
?>

RUN docker-php-ext-install \
  <?php echo join(" \\ \n  ", $phpExtensions) ?>


# Install Xdebug (but don't enable)
<?php $xdebugVersion = ($xdebugVersion == 'latest' || $xdebugVersion == '') ? '' : '-' . $xdebugVersion; ?>
RUN pecl install -o -f <?php printf("xdebug%s\n", $xdebugVersion) ?>

ENV PHP_MEMORY_LIMIT 2G
ENV PHP_ENABLE_XDEBUG false
ENV MAGENTO_ROOT /var/www/magento

ENV DEBUG false
ENV UPDATE_UID_GID false

ADD etc/php-xdebug.ini /usr/local/etc/php/conf.d/zz-xdebug-settings.ini
ADD etc/mail.ini /usr/local/etc/php/conf.d/zz-mail.ini

ADD docker-entrypoint.sh /docker-entrypoint.sh

RUN ["chmod", "+x", "/docker-entrypoint.sh"]

ENTRYPOINT ["/docker-entrypoint.sh"]

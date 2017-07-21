FROM cweagans/bg-sync:latest

MAINTAINER Tomas Gerulaitis <tomas.gerulaitis@meanbee.com>

COPY magento/ /var/www/magento/
# The order of the chown and VOLUME instructions is important to preserve file ownership
RUN chown -R 33:33 /var/www/magento
VOLUME /var/www/magento

COPY run.sh /usr/local/bin

ENV SYNC_SOURCE=/var/www/magento/
ENV SYNC_MAX_INOTIFY_WATCHES=64000

CMD ["run.sh"]

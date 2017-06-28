FROM nginx:1.9

MAINTAINER Nick Jones <nick@nicksays.co.uk>

ADD etc/vhost.conf /etc/nginx/conf.d/default.conf
COPY etc/certs/ /etc/nginx/ssl/
ADD bin/* /usr/local/bin/

EXPOSE 443

ENV FPM_HOST fpm
ENV FPM_PORT 9000
ENV MAGENTO_ROOT /var/www/magento
ENV MAGENTO_RUN_MODE developer
ENV DEBUG false

ENTRYPOINT ["/usr/local/bin/docker-environment"]
CMD ["nginx", "-g", "daemon off;"]

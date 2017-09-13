#!/bin/bash

[ "$DEBUG" = "true" ] && set -x

VHOST_FILE="/etc/nginx/conf.d/default.conf"

[ ! -z "${FPM_HOST}" ] && sed -i "s/!FPM_HOST!/${FPM_HOST}/" $VHOST_FILE
[ ! -z "${FPM_PORT}" ] && sed -i "s/!FPM_PORT!/${FPM_PORT}/" $VHOST_FILE
[ ! -z "${MAGENTO_ROOT}" ] && sed -i "s#!MAGENTO_ROOT!#${MAGENTO_ROOT}#" $VHOST_FILE
[ ! -z "${MAGENTO_RUN_MODE}" ] && sed -i "s/!MAGENTO_RUN_MODE!/${MAGENTO_RUN_MODE}/" $VHOST_FILE
[ ! -z "${UPLOAD_MAX_FILESIZE}" ] && sed -i "s/!UPLOAD_MAX_FILESIZE!/${UPLOAD_MAX_FILESIZE}/" $VHOST_FILE

# Check if the nginx syntax is fine, then launch.
nginx -t

exec "$@"

#!/bin/bash

docker-compose run cli magento-command setup:db-schema:upgrade

cat backup.sql | docker exec -i dockermagento2_db_1 /usr/bin/mysql -u root --password=magento2 magento2

#!/bin/bash

docker exec dockermagento2_db_1 /usr/bin/mysqldump -u magento2 --password=magento2 magento2 > backup.sql

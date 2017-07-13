# meanbee/magento2-data

Docker data images with Magento 2 source code and bi-directional file syncing.

## Usage

The images are intended to be used as [data containers](https://docs.docker.com/engine/tutorials/dockervolumes/#creating-and-mounting-a-data-volume-container), e.g.:

    version: "2"
    services:
        data:
            image: meanbee/magento2-data:2.1
        web:
            image: meanbee/magento2-nginx:1.9
            volumes_from:
                - data
        fpm:
            image: meanbee/magento2-php:7.0-fpm
            volumes_from:
                - data

For development environments, you may want to expose the Magento 2 source code to your IDE. Since Docker on OS X and Windows performs poorly with large file systems mounted to containers, we recommend using the [Unison](https://www.cis.upenn.edu/~bcpierce/unison/) syncing built into the image:

    version: "2"
    services:
        data:
            image: meanbee/magento2-data:2.1
            volumes:
                - /path/to/project:/src
            environment:
                - SYNC_DESTINATION=/src/magento
            privileged: true

## Building images

The `Dockerfile` expects the Magento 2 source code to be located in the `magento/` directory for building. Use the included image builder script to download it with Composer before building the image:

    bash image-builder.sh --version 2.x [--include-sample-data] [--push]

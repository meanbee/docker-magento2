#!/usr/bin/env bash

set -e # Exit on error

#######################################
# Functions
#######################################

# Output an error message.
function error {
    echo "$@" 1>&2
}

# Output an error message and exit with an error code.
function fail {
    error "$@"
    exit 1
}

# Output an informational message.
function info {
    echo "$@"
}

#######################################
# Options and validation
#######################################

USAGE=$(cat <<- END
Usage:
    image-builder.sh [options] --version NUM

Options:
    --help                  This help message.
    --debug                 Show executed commands.
    --version NUM           (Required) Magento 2 version to build the image for.
    --include-sample-data   Flag to include sample data packages in the image.
    --credentials JSON      Composer Auth credentials to use. If not specified,
                            the value of the COMPOSER_AUTH environment variable
                            will be used.
    --push                  Push the created image to Docker Hub.

END
)

VERSION=
DEBUG=false
SAMPLE_DATA=false
CREDENTIALS="COMPOSER_AUTH"
PUSH=false
IMAGE_NAMESPACE="meanbee"
IMAGE_NAME="magento2-data"
TAG_SUFFIX=""
BUILD_DIRECTORY=$(pwd)
MAGENTO_DIRECTORY="$BUILD_DIRECTORY/magento"

while true; do
    case "$1" in
        --help                  ) echo "$USAGE"; exit 0 ;;
        --debug                 ) DEBUG=true; shift ;;
        --version               )
            [ -z "$2" ] && fail "--version option requires a value!"
            VERSION="$2"
            shift 2
            ;;
        --include-sample-data   ) SAMPLE_DATA=true; TAG_SUFFIX="$TAG_SUFFIX-sample"; shift ;;
        --credentials           )
            [ -z "$2" ] && fail "--credentials option requires a value!"
            CREDENTIALS="COMPOSER_AUTH=$2"
            shift 2
            ;;
        --push                  ) PUSH=true; shift ;;
        --                      ) shift; break ;;
        *                       ) break ;;
    esac
done

[ "$DEBUG" = "true" ] && set -x

[ "$CREDENTIALS" = "COMPOSER_AUTH" ] && [ -z "$COMPOSER_AUTH" ] && \
    fail "Credentials not provided and \$COMPOSER_AUTH variable not set. Downloading Magento 2 source will fail!"

[[ "$VERSION" =~ ^[0-9]+\.[0-9]+$ ]] || \
    fail "Must specify the Magento 2 version in the MAJOR.MINOR format!"

#######################################
# Main
#######################################

DOCKER_RUN="\
    docker run --rm \
    -v $MAGENTO_DIRECTORY:/src \
    -e COMPOSER_ALLOW_SUPERUSER=1 \
    -e $CREDENTIALS \
    meanbee/magento2-php:7.0-cli \
"

# Prepare build directory

info "Cleaning the build directory..."

if [ -e "$MAGENTO_DIRECTORY" ]; then
    if [ ! -d "$MAGENTO_DIRECTORY" ]; then
        fail "Unable to create Magento 2 source directory $MAGENTO_DIRECTORY - file already exists!"
    fi

    # Use Docker to remove Magento 2 source as it is likely owned by root
    $DOCKER_RUN find /src -mindepth 1 -maxdepth 1 -exec rm -rf {} +

    rm -rf $MAGENTO_DIRECTORY
fi

mkdir -p $MAGENTO_DIRECTORY

# Download Magento 2 source

info "Downloading Magento 2 source code..."

$DOCKER_RUN composer create-project \
    --no-interaction \
    --repository-url=https://repo.magento.com/ \
    magento/project-community-edition=$VERSION.* \
    /src

if [ "$SAMPLE_DATA" = "true" ]; then
    info "Downloading sample data..."

    $DOCKER_RUN php /src/bin/magento sampledata:deploy
fi

# Build the docker image

info "Building image..."

docker build -t $IMAGE_NAME $BUILD_DIRECTORY

# Generate the list of tags to apply
TAGS="$VERSION"

if [[ "$($DOCKER_RUN php /src/bin/magento --version)" =~ Magento\ CLI\ version\ ([0-9.]+) ]]; then
    TAGS="$TAGS ${BASH_REMATCH[1]}"
fi

# Tag and push the docker image

for tag in $TAGS; do
    full_tag="$IMAGE_NAMESPACE/$IMAGE_NAME:$tag$TAG_SUFFIX"

    info "Tagging $full_tag..."

    docker tag $IMAGE_NAME $full_tag

    if [ "$PUSH" = "true" ]; then
        info "Pushing $full_tag to Docker Hub..."
        docker push $full_tag
    fi
done

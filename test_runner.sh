#!/bin/bash

################################################################################
# Ensure our environment variables are set
################################################################################
if [ "$PHP_VERSION" == "" ]; then
  echo "You must define a \$PHP_VERSION environment variable"
  exit 1
fi

if [ "$IMAGE_FLAVOUR" == "" ]; then
  echo "You must define a \$IMAGE_FLAVOUR environment variable"
  exit 1
fi

if [ "$DOCKER_IP" == "" ]; then
  DOCKER_IP="$(dinghy ip)"
fi

################################################################################
# Set our variables
################################################################################
IMAGE_NAME="test-$PHP_VERSION-$IMAGE_FLAVOUR"
TEST_DIR="$(pwd)/test"
TEST_OK_STRING="TEST OK"

################################################################################
# Kick off with some debug
################################################################################
echo ""
echo "Test Runner Configuration:"
echo ""
echo "PHP Version: $PHP_VERSION"
echo "Image Flavour: $IMAGE_FLAVOUR"

################################################################################
# Pull published image down so we can try and reuse layers
################################################################################
echo ""
echo "Pulling published images for layer cache.."
echo ""
docker pull meanbee/magento2-php:${PHP_VERSION}-${IMAGE_FLAVOUR}

################################################################################
# Build the image locally and name it $IMAGE_NAME
################################################################################
echo ""
echo "Building image"
echo ""
docker build --tag $IMAGE_NAME ${PHP_VERSION}-${IMAGE_FLAVOUR}/

################################################################################
# Output the PHP version running in the image
################################################################################
echo ""
echo "Image PHP Version:"
echo ""
docker run --rm -h test.host $IMAGE_NAME php --version || exit 1

################################################################################
# Run CLI tests on all images
################################################################################
echo ""
echo "Running cli tests:"
echo ""

docker run --rm -h test.host --volume $TEST_DIR:/test $IMAGE_NAME php /test/test.php  | tee /tmp/test.log
grep "$TEST_OK_STRING" /tmp/test.log > /dev/null || exit 1
rm -f /tmp/test.log

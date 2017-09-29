<?php
/**
 * Magento Requirement Tests
 */

class Checker
{
  private $errorCount = 0;

  public function error($message) {
    printf("[ERROR] %s\n", $message);
    $this->errorCount++;
  }

  public function info($message) {
    printf("[INFO] %s\n", $message);
  }

  public function isOk() {
    return $this->errorCount == 0;
  }
}

$checker = new Checker();

// Output PHP Version
$checker->info(sprintf("PHP Version: %s", phpversion()));

// Check required extensions
$required_extensions = array(
  'curl',
  'dom',
  'gd',
  'hash',
  'iconv',
  'mcrypt',
  'memcached',
  'pcre',
  'pdo',
  'pdo_mysql',
  'simplexml',
  'xsl',
  'xdebug',
  'IonCube Loader',
  'zip',
  'intl'
);

// remove IoCube Loader from required extensions if php version is greater than/equal to 7.1
if (version_compare(phpversion(), '7.1.0') >= 0) {
    $key = array_search('IonCube Loader', $required_extensions);
    if (false !== $key) {
        unset($required_extensions[$key]);
    }
}

foreach ($required_extensions as $extension) {
  if (!extension_loaded($extension)) {
    $checker->error(sprintf("Extension '%s' is not loaded", $extension));
  } else {
    $checker->info(sprintf("Extension '%s' is loaded OK", $extension));
  }
}

// Output result
if ($checker->isOK()) {
    printf("\nTEST OK\n");
} else {
    printf("\nTEST NOT OK\n");
}

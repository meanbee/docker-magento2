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
  'pcre',
  'pdo',
  'pdo_mysql',
  'simplexml',
  'xsl',
  'zip',
  'intl'
);

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

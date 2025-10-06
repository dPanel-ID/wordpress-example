#!/bin/bash

# pre-define variables
CURRENT_DIR=$(PWD)
LINUX_USER=$(whoami)
APP_NAME=$(basename "$CURRENT_DIR")
FPM_DIR=/home/${LINUX_USER}/run/php-fpm

php-fpm --nodaemonize --fpm-config ${FPM_DIR}/${APP_NAME}.conf

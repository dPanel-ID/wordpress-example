#!/bin/bash

composer install --optimize-autoloader --no-dev

# pre-define variables
CURRENT_DIR=$(PWD)
LINUX_USER=$(whoami)
APP_NAME=$(basename "$CURRENT_DIR")
FPM_DIR=/home/${LINUX_USER}/run/php-fpm

# create fpm folder if not exist
if [ ! -d "${FPM_DIR}" ]; then
  mkdir -p ${FPM_DIR}
fi

# create fpm config
cat > ${FPM_DIR}/${APP_NAME}.conf <<EOL
[global]
pid = /home/${LINUX_USER}/logs/${APP_NAME}/process.pid
error_log = /home/${LINUX_USER}/logs/${APP_NAME}/php-error.log

[${APP_NAME}]
listen = ${FPM_DIR}/${APP_NAME}.sock
listen.allowed_clients = 127.0.0.1

clear_env = no

pm = static
pm.max_children = 3
pm.start_servers = 2
pm.min_spare_servers = 2
pm.max_spare_servers = 2
pm.max_requests = 100

php_admin_flag[display_errors] = off
php_admin_flag[log_errors] = on
php_admin_value[error_log] = /home/${LINUX_USER}/logs/${APP_NAME}/\$pool.error.log

slowlog=/home/${LINUX_USER}/logs/${APP_NAME}/\$pool.slow.log
request_slowlog_timeout=10s
EOL
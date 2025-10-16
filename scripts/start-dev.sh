#!/bin/bash

export PORT=8081
export CURRENT_DIR=$(PWD)
export LINUX_USER=$(whoami)
export APP_NAME=$(basename "$CURRENT_DIR")
export FRANKEN_DIR=${CURRENT_DIR}/development

./development/frankenphp run --config ./development/wordpress-example.Caddyfile

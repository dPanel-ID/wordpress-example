#!/bin/bash


CURRENT_DIR=$(PWD)
LINUX_USER=$(whoami)
APP_NAME=$(basename "$CURRENT_DIR")
FRANKEN_DIR=${CURRENT_DIR}/development

./development/frankenphp run --config ./development/wordpress-example.Caddyfile

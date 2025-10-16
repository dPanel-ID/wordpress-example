#!/bin/bash


CURRENT_DIR=$(PWD)
LINUX_USER=$(whoami)
APP_NAME=$(basename "$CURRENT_DIR")
FRANKEN_DIR=/home/${LINUX_USER}/run/frankenphp

./development/frankenphp run --config ./development/wordpress-example.Caddyfile

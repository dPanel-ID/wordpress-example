#!/bin/bash


export CURRENT_DIR=$(PWD)
export LINUX_USER=$(whoami)
export APP_NAME=$(basename "$CURRENT_DIR")
export FRANKEN_DIR=/home/${LINUX_USER}/run/frankenphp

frankenphp run --config ${FRANKEN_DIR}/${APP_NAME}.Caddyfile

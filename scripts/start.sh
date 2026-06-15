#!/bin/bash


export CURRENT_DIR=$(pwd)
export LINUX_USER=$(whoami)
export APP_NAME=$(basename "$CURRENT_DIR")
export FRANKEN_DIR=${CURRENT_DIR}/run/frankenphp

frankenphp run --config ${FRANKEN_DIR}/${APP_NAME}.Caddyfile

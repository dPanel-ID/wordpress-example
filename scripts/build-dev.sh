#!/bin/bash

set -e

# predefine variables
PORT=8081
CURRENT_DIR=$(pwd)
LINUX_USER=$(whoami)
APP_NAME=$(basename "$CURRENT_DIR")
FRANKEN_DIR=${CURRENT_DIR}/development

# shutdown all docker compose services if running
docker compose down --volumes --remove-orphans

# check OS architecture to running docker compose based on the system architecture
ARCH=$(uname -m)

if [[ "$ARCH" == "x86_64" ]]; then
  echo "Running on x86_64 architecture"
  # Use the standard image for x86_64
  export PHPMYADMIN_IMAGE="phpmyadmin/phpmyadmin:5.2.3"
elif [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]]; then
  echo "Running on ARM64 architecture"
  # Use the ARM64 image for aarch64
  export PHPMYADMIN_IMAGE="arm64v8/phpmyadmin:5.2.3"
else
  echo "Unsupported architecture: $ARCH"
  exit 1
fi

# running docker compose backround
docker compose up -d

# create frankenphp config folder if not exist and install frankenPHP
if [ ! -f "${FRANKEN_DIR}/frankenphp" ]; then
  mkdir -p ${FRANKEN_DIR}

  curl https://frankenphp.dev/install.sh | sh
  mv frankenphp ${FRANKEN_DIR}/frankenphp
fi

# install dependencies
composer install --optimize-autoloader --no-dev

# create web caddy web 
cat > ${FRANKEN_DIR}/${APP_NAME}.Caddyfile << EOL
{
   	{\$CADDY_GLOBAL_OPTIONS}

	admin off
	auto_https off

	frankenphp {
		{\$FRANKENPHP_CONFIG}
	}
	order php_server before file_server
	order php before file_server
}
{\$CADDY_EXTRA_CONFIG}
:{\$PORT} {
	# Remove Via and Powered-By headers
	header {
		-Via
		-X-Powered-By
	}

	# Disallowed request pattern
	@disallowedPath {
		path /.git*
		path /.env*
		path *.sql
		path *.sh
		path *.gitignore
		path /wp-content/uploads/*.php
	}

	handle @disallowedPath {
		respond "Request Not Allowed" 403
	}

	@static {
		file
		path *.ico *.css *.js *.gif *.jpg *.jpeg *.png *.svg *.woff
	}
	
	root * ${CURRENT_DIR}
	encode zstd br gzip
    
	{\$CADDY_SERVER_EXTRA_DIRECTIVES}
	php_server
}
EOL
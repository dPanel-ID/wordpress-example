#!/bin/bash

# predefine variables
PORT=8081
CURRENT_DIR=$(PWD)
LINUX_USER=$(whoami)
APP_NAME=$(basename "$CURRENT_DIR")
FRANKEN_DIR=${CURRENT_DIR}/development

# create frankenphp config folder if not exist and install frankenPHP
if [ ! -d "${FRANKEN_DIR}" ]; then
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
	
	auto_https off

	frankenphp {
		{\$FRANKENPHP_CONFIG}
	}
	order php_server before file_server
	order php before file_server
}
{\$CADDY_EXTRA_CONFIG}
:${PORT} {
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
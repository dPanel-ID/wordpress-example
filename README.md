## WordPress Example
Deploy wordpress from github repository through dPanel without docker. The wordpress will running behind load balancer. The load balancer will forward the request to the wordpress server which running in defined port.

### Development

To running in development, some prerequisites are required. You need to have MySQL / MariaDB installed. Or you can use docker to run MariaDB. Here, we provide a docker-compose file to run MySQL. You can run it by executing the following command.

```bash
docker-compose up -d
```

After that, you need to follow the steps below.

1. Copy .env.example to .env, and fill the required environment variables.

2. Execute dev build script.

```bash
./scripts/build-dev.sh
```

3. Start development server.

```bash
./scripts/start-dev.sh
```


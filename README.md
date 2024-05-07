# nginx Unit with PHP 7.4

A Dockerfile to build nginx Unit web server with PHP 7.4 module based on the official image.

## Disclaimer

nginx Unit never shipped with PHP 7.4 and by now this version has reached its end of life.
Since you are here you need it for some reason and as did I, so feel free to use it at your own risk.

## Installation

Build included Dockerfile optionally providing nginx Unit version as an argument:

```bash
docker build --build-arg UNIT_VERSION=1.32.1 -t nginx-unit:php7.4 .
```

By providing additional `BASE_IMAGE` argument you can customise [base image](https://hub.docker.com/_/unit/tags) used.
You can also customise PHP extensions right in the `Dockerfile`.

## Test

Run the image using included sample configuration files:

```bash
docker run -p 8074:8080 -v $PWD/.docker/unit.conf.json:/docker-entrypoint.d/unit.conf.json -v $PWD/.docker/index.php:/www/index.php nginx-unit:php7.4
```

Open http://localhost:8074.

## Usage

The [official nginx Unit image](https://hub.docker.com/_/unit) is used and comes with the [same features](https://unit.nginx.org/installation/#initial-configuration).

## License
[MIT](https://choosealicense.com/licenses/mit/)

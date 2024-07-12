# nginx Unit with PHP 7.4 [![Docker Pulls](https://img.shields.io/docker/pulls/skauk/unit-php7.4)](https://hub.docker.com/repository/docker/skauk/unit-php7.4)

A Dockerfile to build nginx Unit web server with PHP 7.4 module based on the official image.

## Disclaimer

nginx Unit never shipped with PHP 7.4 and by now this version has reached its end of life.
Since you are here you need it for some reason and so did I, so feel free to use it at your own risk.

## Installation

Build included Dockerfile optionally providing nginx Unit official image tag as an argument:

```bash
docker build --build-arg BASE_IMAGE=minimal -t nginx-unit:php7.4 .
```

By providing additional `BASE_IMAGE` argument you can customise [base image](https://hub.docker.com/_/unit/tags) used 
(Defaults to `minimal` which is the same as `latest`.).
You can also customise PHP extensions right in the `Dockerfile`.

## Test

Run the image using included sample configuration file:

```bash
docker run -p 8074:8080 -v $PWD/.docker/unit.conf.json:/docker-entrypoint.d/unit.conf.json -v $PWD/.docker/index.php:/www/index.php nginx-unit:php7.4
```

Open http://localhost:8074 to see PHP info page.

## Usage

The [official nginx Unit image](https://hub.docker.com/_/unit) is used and comes with the [same features](https://unit.nginx.org/installation/#initial-configuration).

## License
[MIT](https://choosealicense.com/licenses/mit/)

ARG BASE_IMAGE=minimal
FROM unit:$BASE_IMAGE AS base

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install ca-certificates \
    && curl -o /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb https://packages.sury.org/php/ bullseye main" | tee /etc/apt/sources.list.d/php.list \
    && apt-get update && apt-get install -y php7.4 php7.4-cgi libphp7.4-embed

FROM base AS build

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get install -y --no-install-recommends build-essential php7.4-dev

# Compile PHP 7.4 module
RUN UNIT_VERSION=$(unitd --version 2>&1 | grep 'version:' | cut -d' ' -f3) \
    UNIT_CONFIGURE=$(unitd --version 2>&1 | grep './configure' | sed -E 's/.*(\.\/configure)/\1/' | sed 's/--njs//' | sed "s/--ld-opt='.*'//") \
    && curl -sL "https://unit.nginx.org/download/unit-$UNIT_VERSION.tar.gz" | tar xzf - \
    && cd "$PWD/unit-$UNIT_VERSION" \
    && eval "$UNIT_CONFIGURE" \
    && ./configure php --module=php7.4 --config=php-config \
    && make php7.4 \
    && cp build/lib/unit/modules/php7.4.unit.so /tmp

FROM build

COPY --from=build /tmp/php7.4.unit.so /usr/lib/unit/modules/

# Customise PHP extensions
RUN apt-get install -y \
        php7.4-apcu \
        php7.4-bcmath \
        php7.4-curl \
        php7.4-gd \
        php7.4-intl \
        php7.4-pgsql \
        php7.4-xdebug \
        php7.4-zip \
    && apt-get clean autoclean && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/

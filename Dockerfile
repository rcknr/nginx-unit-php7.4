ARG UNIT_VERSION=1.32.1
ARG BASE_IMAGE=$UNIT_VERSION-minimal

FROM unit:$BASE_IMAGE as base

ARG UNIT_VERSION
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install ca-certificates \
    && curl -o /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb https://packages.sury.org/php/ bullseye main" | tee /etc/apt/sources.list.d/php.list \
    && apt-get update && apt-get install -y php7.4 php7.4-cgi libphp7.4-embed

FROM base as builder
ARG UNIT_VERSION

RUN apt-get install -y --no-install-recommends build-essential php7.4-dev

RUN curl -L "https://unit.nginx.org/download/unit-$UNIT_VERSION.tar.gz" | tar xzf -
WORKDIR "$PWD/unit-$UNIT_VERSION"
RUN ./configure --prefix=/usr --statedir=/var/lib/unit --control=unix:/var/run/control.unit.sock \
    --pid=/var/run/unit.pid --log=/var/log/unit.log --tmpdir=/var/tmp --user=unit --group=unit \
    --openssl --libdir=/usr/lib/x86_64-linux-gnu --cc-opt='-g -O2 -fdebug-prefix-map=/unit=. \
    -specs=/usr/share/dpkg/no-pie-compile.specs -fstack-protector-strong -Wformat -Werror=format-security \
    -Wp,-D_FORTIFY_SOURCE=2 -fPIC' --modulesdir=/usr/lib/unit/modules
RUN ./configure php --module=php7.4 --config=php-config
RUN make php7.4
RUN cp build/lib/unit/modules/php7.4.unit.so /tmp

FROM base

# Customise PHP extensions
RUN apt-get install -y \
        php7.4-apcu \
        php7.4-bcmath \
        php7.4-curl \
        php7.4-gd \
        php7.4-intl \
        php7.4-pgsql \
        php7.4-xdebug \
        php7.4-zip

COPY --from=builder /tmp/php7.4.unit.so /usr/lib/unit/modules/

RUN apt-get clean autoclean && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/

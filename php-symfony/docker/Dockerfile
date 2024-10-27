FROM dunglas/frankenphp:1-php8.3 AS app_base

WORKDIR /app

VOLUME /app/var/

# persistent / runtime deps
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
	acl \
	file \
	gettext \
	git \
	&& rm -rf /var/lib/apt/lists/*

RUN set -eux; \
	install-php-extensions \
		@composer \
		apcu \
		intl \
		opcache \
		zip \
	;

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER=1

CMD [ "frankenphp", "run", "--config", "/etc/caddy/Caddyfile" ]

# Dev FrankenPHP image
FROM app_base AS app_dev

ENV APP_ENV=dev

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

RUN set -eux; \
	install-php-extensions \
		xdebug \
	;

RUN set -eux; \
	docker-php-ext-enable \
		xdebug \
	;

COPY docker/caddy/Caddyfile /etc/caddy/Caddyfile
COPY docker/php/conf.d/ $PHP_INI_DIR/conf.d

FROM app_dev AS app_demo

COPY . /app/

RUN composer install && composer run-script prepare-demo


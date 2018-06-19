FROM xataz/alpine:3.7

LABEL Description="walabag based on alpine" \
      tags="latest 2.3.2 2.3 2" \
      maintainer="xataz <https://github.com/xataz>" \
      build_ver="201806190432"

ARG WALLABAG_VER=2.3.2

ENV DB_TYPE=sqlite \
    DB_HOST=wallabag-db \
    DB_PORT=~ \
    DB_NAME=wallabag \
    DB_USER=wallabag \
    DB_PASS=~ \
    MAIL_HOST=127.0.0.1 \
    MAIL_USER=~ \
    MAIL_PASS=~ \
    MAIL_ADRESS=wallabag@mydomain.tld \
    DOMAIN_NAME=http://wallabag.mydomain.tld \
    SECRET=ovkdslhHIDMSkgdklDSMIKHDgfkldf \
    ENABLE_REGISTRATION=false \
    ENABLE_RABBITMQ=false \
    RABBITMQ_HOST=rabbitmq \
    RABBITMQ_PORT=5672 \
    RABBITMQ_USER=guest \
    RABBITMQ_PASS=guest \
    ENABLE_REDIS=false \
    REDIS_HOST=redis \
    REDIS_PORT=6379 \
    REDIS_PASS=null \
    UID=991 \
    GID=991

RUN BUILD_DEPS="go \
                build-base" \
    && apk add --no-cache \
                    curl \
                    git \
                    libwebp \
                    mariadb-client \
                    nginx \
                    pcre \
                    php7 \
                    php7-amqp \
                    php7-bcmath \
                    php7-ctype \
                    php7-curl \
                    php7-dom \
                    php7-fpm \
                    php7-gd \
                    php7-gettext \
                    php7-iconv \
                    php7-json \
                    php7-mbstring \
                    php7-openssl \
                    php7-pdo_mysql \
                    php7-pdo_pgsql \
                    php7-pdo_sqlite \
                    php7-phar \
                    php7-session \
                    php7-simplexml \
                    php7-tokenizer \
                    php7-xml \
                    php7-zlib \
                    php7-opcache \
                    php7-apcu \
                    rabbitmq-c \
                    s6 \
                    tar \
                    su-exec \
                    postgresql-client \
                    sqlite \
                    mariadb-client \
                    ${BUILD_DEPS} \
    && curl -s https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && git clone --branch ${WALLABAG_VER} https://github.com/wallabag/wallabag.git /app/wallabag \
    && rm -rf /app/wallabag/.git \
    # gucci
    && mkdir -p /tmp/go/bin/ \
    && export GOPATH=/tmp/go \
    && go get github.com/noqcks/gucci \
    && mv /tmp/go/bin/gucci /usr/local/bin/gucci \
    # Cleanup
    && apk del --no-cache ${BUILD_DEPS} \
    && rm -rf /tmp/*

COPY rootfs /
RUN chmod +x /usr/local/bin/startup \
    && cd /app/wallabag \
    && SYMFONY_ENV=prod composer install --no-dev -o --prefer-dist \
    && rm -rf /root/.composer

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/startup"]
CMD ["/bin/s6-svscan", "/etc/s6.d"]

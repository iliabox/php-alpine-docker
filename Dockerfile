FROM alpine:3.10

ENV WD=/var/www/app
ENV COMPOSER_MEMORY_LIMIT=-1

RUN apk update \
    && apk add --no-cache git nginx supervisor curl composer fcgi \
        php7-fpm php7-pcntl php7-intl php7-dom php7-mbstring php7-mysqlnd php7-opcache php7-tidy php7-xml php7-zip php7-xsl php7-sysvsem php7-fileinfo php7-simplexml php7-pdo php7-tokenizer php7-xmlwriter php7-ctype php7-gd php7-bcmath php7-bz2 php7-calendar php7-iconv php7-mbstring php7-pdo_mysql php7-pdo_pgsql php7-pgsql php7-soap php7-zip php7-curl php7-xmlreader php7-apcu

RUN mkdir -p $WD \
    && mkdir -p /var/run/php-fpm/ \
    && chown -R nginx:nginx /var/run/php-fpm/ \
    && mkdir -p /etc/supervisor.d/ \
    && mkdir -p /run/nginx/ \
    && rm -f /etc/nginx/conf.d/default.conf \
    && sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisord.conf \
    && sed -i 's/# server_tokens off/server_tokens off/'  /etc/nginx/nginx.conf \
    && sed -i 's/memory_limit = 128M/memory_limit = 1024M/' /etc/php7/php.ini \
    && sed -i 's/max_execution_time = 30/max_execution_time = 60/' /etc/php7/php.ini \
    && sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 20M/' /etc/php7/php.ini \
    && sed -i 's/post_max_size = 2M/post_max_size = 20M/' /etc/php7/php.ini

CMD ["supervisord", "-c", "/etc/supervisord.conf"]


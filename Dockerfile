FROM php:7-fpm-alpine

RUN apk add --no-cache oniguruma-dev nginx

RUN docker-php-ext-install mbstring pdo_mysql

RUN rm -rf /var/www/*
# Supprimer TOUTES les configs Nginx par défaut pour éviter les conflits de port
RUN rm -f /etc/nginx/conf.d/*.conf /etc/nginx/http.d/*.conf

RUN mkdir -p /run/nginx /etc/nginx/snippets /var/www/Application /var/www/Data /var/www/html/img/brand /var/www/html/img/backdrops

ADD Website/Public /var/www/html
ADD Website/Application /var/www/Application
ADD Website/Data /var/www/Data
ADD Website/Submodules /var/www/Submodules

RUN chmod +x /var/www/Data

COPY Website/Packaging/Version /var/www/Packaging/Version
COPY Website/PHP.ini /usr/local/etc/php/php.ini

COPY api-keys.json /var/www/Data/api-keys.json

# Fichiers NGINX
COPY Website/NGINX/Default.conf /etc/nginx/conf.d/default.conf
COPY Website/NGINX/Locations.conf /etc/nginx/snippets/locations.conf
COPY Website/NGINX/Domains.conf /etc/nginx/snippets/domains.conf
COPY Website/NGINX/Custom.conf /etc/nginx/snippets/custom.conf

# Chemins Branding
COPY Branding/Main/Big.png /var/www/html/img/brand/big.png
COPY Branding/Main/Small.png /var/www/html/img/brand/small.png
COPY Branding/Backdrops/Main.png /var/www/html/img/backdrops/about.png
COPY Branding/Backdrops/Bricks.png /var/www/html/img/backdrops/admin.png

# Liens symboliques
RUN ln -s /var/www/Data/Thumbnails /var/www/html/img/thumbnails 2>/dev/null || true
RUN ln -s /var/www/Data/Client /var/www/html/api/setup/files 2>/dev/null || true

EXPOSE 8080

COPY Website/Entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/bin/sh", "/usr/local/bin/entrypoint.sh"]

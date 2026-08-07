#!/bin/sh

# Permissions
chown -R nobody:nobody /var/www /run/nginx /var/log/nginx 2>/dev/null || true

# Railway définit automatiquement $PORT. Si absente, on fallback sur 8080.
PORT_TO_LISTEN=${PORT:-8080}
echo "Attribution du port $PORT_TO_LISTEN pour Nginx..."

# Injection du port Railway dans la conf Nginx
sed -i "s/listen .*/listen $PORT_TO_LISTEN;/g" /etc/nginx/conf.d/default.conf 2>/dev/null || true

php-fpm -D

nginx -t
if [ $? -ne 0 ]; then
  exit 1
fi

echo "Lancement de Nginx sur le port $PORT_TO_LISTEN..."
exec nginx -g 'daemon off;'

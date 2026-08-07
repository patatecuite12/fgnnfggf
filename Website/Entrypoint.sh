#!/bin/sh

# Redirection des logs Nginx vers la console de Railway
ln -sf /dev/stdout /var/log/nginx/access.log 2>/dev/null || true
ln -sf /dev/stderr /var/log/nginx/error.log 2>/dev/null || true

# Lancement de PHP-FPM en arrière-plan
php-fpm -D

# Test de la configuration Nginx
nginx -t
if [ $? -ne 0 ]; then
  echo "Erreur de syntaxe Nginx !"
  exit 1
fi

echo "Lancement de Nginx au premier plan sur 8080..."
exec nginx -g 'daemon off;'

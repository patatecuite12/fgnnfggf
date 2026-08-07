#!/bin/sh

# Ajustement des permissions pour Alpine Linux
chown -R nobody:nobody /var/www /run/nginx /var/log/nginx 2>/dev/null || true

# Lancement de PHP-FPM en arrière-plan
php-fpm -D
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start php-fpm: $status"
  exit $status
fi

echo "PHP-FPM démarré avec succès."

# Lancement de Nginx au premier plan (garde le conteneur actif)
echo "Démarrage de Nginx sur le port 8080..."
exec nginx -g 'daemon off;'

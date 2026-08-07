#!/bin/sh

# Permissions
chown -R nobody:nobody /var/www /run/nginx /var/log/nginx 2>/dev/null || true

# Récupération du port envoyé par Railway (ou 8080 par défaut)
TARGET_PORT=${PORT:-8080}
echo "Attribution du port $TARGET_PORT pour Nginx..."

# Forcer l'écoute sur 0.0.0.0:<PORT>
sed -i -E "s/listen .*/listen 0.0.0.0:$TARGET_PORT;/g" /etc/nginx/conf.d/default.conf 2>/dev/null || true

# Lancement de PHP-FPM
php-fpm -D
if [ $? -ne 0 ]; then
  echo "Erreur PHP-FPM"
  exit 1
fi

echo "PHP-FPM démarré avec succès."

# Validation Nginx
nginx -t
if [ $? -ne 0 ]; then
  echo "Erreur de configuration Nginx"
  exit 1
fi

# Lancement de Nginx au premier plan
echo "Lancement de Nginx sur 0.0.0.0:$TARGET_PORT..."
exec nginx -g 'daemon off;'

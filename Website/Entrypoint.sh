#!/bin/sh

# Adapter les permissions
chown -R nobody:nobody /var/www /run/nginx /var/log/nginx 2>/dev/null || true

# Récupérer le port Railway (ou 8080 par défaut)
TARGET_PORT=${PORT:-8080}
echo "Attribution du port $TARGET_PORT pour Nginx..."

# Remplacer le port dans le fichier de config Nginx
sed -i "s/listen .*/listen $TARGET_PORT;/g" /etc/nginx/conf.d/default.conf 2>/dev/null || true

# Démarrer PHP-FPM
php-fpm -D
if [ $? -ne 0 ]; then
  echo "Erreur lors du démarrage de PHP-FPM"
  exit 1
fi

echo "PHP-FPM démarré avec succès."

# Tester la configuration Nginx avant lancement
nginx -t
if [ $? -ne 0 ]; then
  echo "Erreur dans la configuration Nginx !"
  exit 1
fi

# Démarrer Nginx au premier plan
echo "Lancement de Nginx sur 0.0.0.0:$TARGET_PORT..."
exec nginx -g 'daemon off;'

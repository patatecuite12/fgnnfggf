#!/bin/sh

# 1. Ajustement des permissions
chown -R nobody:nobody /var/www /run/nginx /var/log/nginx 2>/dev/null || true

# 2. Récupération du port
TARGET_PORT=${PORT:-8080}
echo "Attribution du port $TARGET_PORT pour Nginx..."

# 3. Modification de la configuration Nginx
sed -i "s/listen .*/listen $TARGET_PORT;/g" /etc/nginx/conf.d/default.conf 2>/dev/null || true

# 4. Lancement de PHP-FPM en arrière-plan
php-fpm -D
if [ $? -ne 0 ]; then
  echo "Erreur PHP-FPM"
  exit 1
fi

echo "PHP-FPM démarré avec succès."

# 5. Test de la config Nginx
nginx -t
if [ $? -ne 0 ]; then
  echo "Erreur de configuration Nginx"
  exit 1
fi

# 6. TOUT A LA FIN : Lancement final de Nginx
echo "Lancement de Nginx sur le port $TARGET_PORT..."
exec nginx -g 'daemon off;'

#!/bin/bash
set -ex

# Importamos las variables de entorno
source .env_frontend

# Eliminamos descargas previas de WP-CLI
rm -f /tmp/wp-cli.phar

# Descargamos WP-CLI
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /tmp

# Le asignamos permisos de ejecución
chmod +x /tmp/wp-cli.phar

# Movemos wp-cli.phar a /usr/local/bin/wp
mv /tmp/wp-cli.phar /usr/local/bin/wp

# Eliminamos instalaciones previas de WordPress
rm -rf /var/www/html/*

# Descargamos WordPress en español
wp core download --locale=es_ES --path=/var/www/html --allow-root

# -----------------------------------------------------------------
# AQUÍ HEMOS BORRADO LAS LÍNEAS DE MYSQL (CREATE DATABASE, ETC.)
# Esa tarea ya la hizo el script del Backend.
# -----------------------------------------------------------------

# Creamos el archivo wp-config.php conectando al HOST REMOTO ($DB_HOST)
wp config create \
  --dbname=$DB_NAME \
  --dbuser=$DB_USER \
  --dbpass=$DB_PASSWORD \
  --dbhost=$DB_HOST \
  --path=/var/www/html \
  --allow-root

# Instalamos WordPress
wp core install \
  --url=$CERTBOT_DOMAIN \
  --title="$WORDPRESS_TITLE" \
  --admin_user=$WORDPRESS_ADMIN_USER \
  --admin_password=$WORDPRESS_ADMIN_PASSWORD \
  --admin_email=$WORDPRESS_ADMIN_EMAIL \
  --path=/var/www/html \
  --allow-root  

# Configuramos los enlaces permanentes
wp rewrite structure '/%postname%/' --path=/var/www/html --allow-root

# Instalamos y activamos el plugin WPS Hide Login
wp plugin install wps-hide-login --activate --path=/var/www/html --allow-root

# Configuramos la URL personalizada de login
wp option update whl_page $URL_HIDE_LOGIN --path=/var/www/html --allow-root

# Copiamos el .htaccess (Solo si tienes este archivo en esa ruta relativa)
# Si no tienes un .htaccess personalizado, WP genera uno básico automáticamente tras configurar los permalinks.
# cp ../htaccess/.htaccess /var/www/html 

# Permisos finales
chown -R www-data:www-data /var/www/html
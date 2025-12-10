#!/bin/bash
set -ex

# Importamos las variables de entorno
source .env_frontend

# -------------------------------------------------------------
# 1. CONFIGURACIÓN DE APACHE (CRÍTICO PARA EL ERROR 404)
# -------------------------------------------------------------

# Habilitamos el módulo rewrite de Apache
a2enmod rewrite

# Editamos apache2.conf para permitir AllowOverride All en /var/www/
# Esto permite que WordPress gestione sus propias URL (permalinks) y que funcione /secreto
sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Reiniciamos Apache para aplicar los cambios de configuración INMEDIATAMENTE
systemctl restart apache2

# -------------------------------------------------------------
# 2. INSTALACIÓN DE WORDPRESS
# -------------------------------------------------------------

# Eliminamos descargas previas de WP-CLI
rm -f /tmp/wp-cli.phar

# Descargamos WP-CLI
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /tmp

# Le asignamos permisos de ejecución
chmod +x /tmp/wp-cli.phar

# Movemos wp-cli.phar a /usr/local/bin/wp
mv /tmp/wp-cli.phar /usr/local/bin/wp

# Eliminamos instalaciones previas de WordPress (Limpieza)
rm -rf /var/www/html/*

# Descargamos WordPress en español
wp core download --locale=es_ES --path=/var/www/html --allow-root

# Creamos el archivo wp-config.php conectando al HOST REMOTO ($DB_HOST)
# IMPORTANTE: Asegúrate que en .env_frontend DB_HOST es la IP privada de la otra máquina
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

# -------------------------------------------------------------
# 3. CONFIGURACIÓN DE URLS Y SEGURIDAD
# -------------------------------------------------------------

# Configuramos los enlaces permanentes (Permalinks)
# Esto genera el archivo .htaccess
wp rewrite structure '/%postname%/' --path=/var/www/html --allow-root

# Instalamos y activamos el plugin WPS Hide Login
wp plugin install wps-hide-login --activate --path=/var/www/html --allow-root

# Configuramos la URL personalizada de login
wp option update whl_page "$URL_HIDE_LOGIN" --path=/var/www/html --allow-root
# Copiamos el .htaccess personalizado desde tu carpeta local a la web
cp ../htaccess/.htaccess /var/www/html/.htaccess

# Asignamos permisos finales correctos a todo el directorio
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
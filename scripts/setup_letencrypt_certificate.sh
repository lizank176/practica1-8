#!/bin/bash
set -ex

# Importamos el archivo .env
source .env

# Copiamos la plantilla del archivo VirtualHost en el servidor
cp ../conf/000-default.conf /etc/apache2/sites-available

# Configuramos el ServerName en el VirtualHost
sed -i "s/PUT_YOUR_CERTBOT_DOMAIN_HERE/$CERTBOT_DOMAIN/" /etc/apache2/sites-available/000-default.conf

# Instalamos snap
snap install core
snap refresh core

# Eliminamos instalaciones previas de certbot
apt remove certbot -y

# Instalamos certbot
snap install --classic certbot

# Solicitando el certificado a Let´s Encrypt
certbot --apache -m $CERTBOT_EMAIL --agree-tos --no-eff-email -d $CERTBOT_DOMAIN --non-interactive


#!/bin/bash

#-e: Finaliza el script cuando hay error
#-x: Muestra el comando por pantalla
set -ex

#Actualizamos repositorios
apt update

#Actualizamos paquetes
apt upgrade -y

#Instalamos apache
apt install apache2 -y

#Instalamos php
apt install php libapache2-mod-php php-mysql -y

#Copiamos el archivo de configuracion de apache
cp ../conf/000-default.conf /etc/apache2/sites-available
#Reiniciamos apache
systemctl restart apache2

#Copiamos nuestro archivo de prueba php a /var/www/html
cp ../php/index.php /var/www/html

#!/bin/bash
#-e: Finaliza el script cuando hay error
#-x: Muestra el comando por pantalla
set -ex
#Importamos el archivo de variables
source .env

#Creamos la base de datos de wordpress y el usuario

mysql -u root -e "CREATE DATABASE IF NOT EXISTS $WORDPRESS_DB_NAME;"

# Borrar usuario anterior si existe
mysql -u root -e "DROP USER IF EXISTS '$WORDPRESS_DB_USER'@'%';"

# Crear usuario nuevo
mysql -u root -e "CREATE USER '$WORDPRESS_DB_USER'@'%' IDENTIFIED BY '$WORDPRESS_DB_PASSWORD';"

# Dar permisos al usuario sobre la base de datos
mysql -u root -e "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO '$WORDPRESS_DB_USER'@'%';"




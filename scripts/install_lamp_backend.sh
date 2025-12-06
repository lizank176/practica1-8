#!/bin/bash

#-e: Finaliza el script cuando hay error
#-x: Muestra el comando por pantalla
set -ex

#Actualizamos repositorios
apt update

#Actualizamos paquetes
apt upgrade -y

# Instalamos mysql server
sudo apt install mysql-server -y
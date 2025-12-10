# practica1-8
# Documentación Técnica: Arquitectura LAMP en dos niveles (AWS)
## Introducción
El objetivo de esta práctica es automatizar la instalación y configuración de una aplicación web WordPress utilizando una pila LAMP (Linux, Apache, MySQL, PHP) distribuida en dos niveles sobre Amazon Web Services (AWS).
La arquitectura se divide en:
Capa Frontend: Una instancia EC2 con Ubuntu Server, Apache HTTP Server y PHP.
Capa Backend: Una instancia EC2 con Ubuntu Server y MySQL Server.
Ambas máquinas se comunican a través de la red privada de AWS. Además, se ha securizado el acceso mediante HTTPS (Let's Encrypt) y se ha ocultado la URL de administración de WordPress.
## Requisitos Previos e Infraestructura
Para el correcto funcionamiento de los scripts, se han configurado los Security Groups en AWS de la siguiente manera:
Backend (MySQL): Permite tráfico en el puerto 3306 procedente únicamente de la IP Privada del Frontend (o de la subred privada).
Frontend (Apache): Permite tráfico HTTP (80), HTTPS (443) y SSH (22) desde cualquier origen (0.0.0.0/0).
## Configuración de la Capa Backend (MySQL)
El primer paso consistió en aprovisionar la máquina que actuará como base de datos. Es fundamental configurar MySQL para que acepte conexiones externas, ya que el servidor web (Frontend) se conectará a través de la red privada de AWS.
### Instalación y configuración de red (install_lamp_backend.sh)
En este script, instalamos mysql-server y modificamos la configuración bind-address. Por defecto, MySQL solo escucha en 127.0.0.1. Usamos sed para cambiar esto a la IP privada específica, permitiendo así la conexión desde el Frontend.
![alt text]( /lamp_backend.png)
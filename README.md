# Instalación y Configuración de Tomcat en Ubuntu 20.04

Este script Bash automatiza la instalación y configuración de Apache Tomcat 10 en un entorno Ubuntu 20.04. Asegúrate de ejecutar el script con permisos de superusuario.

## Requisitos

- Ubuntu 20.04
- Permisos de superusuario (sudo)

## Instrucciones de Uso

1. Clona este repositorio o copia el contenido del script en un archivo local.

```bash
gh repo clone joseaholgado/script_Tomcat

sudo ./script_tomcat.sh

Detalles del Script
1. Instalación de Tomcat
Actualiza el sistema.
Instala Java 17 JDK y JRE.
Crea el usuario y grupo "tomcat" si no existen.
Descarga Apache Tomcat 10 y lo instala en /opt/tomcat.
Cambia el propietario y permisos del directorio de instalación.
2. Configuración de Usuarios Administradores
Añade roles y usuarios a tomcat-users.xml.
Elimina restricciones por defecto en context.xml.
3. Creación del Servicio del Sistema
Crea el archivo tomcat.service en /etc/systemd/system/.
Configura las variables de entorno y rutas para el servicio.
Inicia y habilita el servicio systemd.
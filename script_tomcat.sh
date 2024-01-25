#!/bin/bash

# Este script instala y configura Tomcat 10 en Ubuntu 20.04
# Se debe ejecutar con permisos de superusuario

# Salir en caso de error
set -e

#1. Instalacion tomcat
# Actualizar el sistema
echo "Actualizando sistema..."
sudo apt update -y
sudo apt upgrade -y

# Instalar Java 17 JDK
sudo apt install openjdk-17-jdk
sudo apt install openjdk-17-jre
java -version

# Creamos un usuario y grupo tomcat si no existen
echo "Creando usuario tomcat..."
if id "tomcat" >/dev/null 2>&1; then
        echo "Usuario tomcat ya existe"
else
        useradd -m -d /opt/tomcat -U -s /bin/false tomcat
fi

echo "Creando grupo grupoTomcat..."
if getent group "grupoTomcat" >/dev/null 2>&1; then
    echo "Grupo grupoTomcat ya existe"
else
    groupadd grupoTomcat
fi

# Asociando el usuario tomcat al grupo grupoTomcat
usermod -aG grupoTomcat tomcat

echo "Usuario y grupo grupoTomcat creados y asociados correctamente."

# Descargamos Apache Tomcat
echo "Descargando Tomcat 10..."
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.18/bin/apache-tomcat-10.1.18.tar.gz -P /tmp

# Creamos un directorio de instalación
echo "Creando directorio de instalación..."
mkdir -p /opt/tomcat

# Descomprimimos Apache Tomcat en el directorio de instalación
echo "Descomprimiendo Tomcat..."
tar xzvf apache-tomcat-10.1.18.tar.gz -C /opt/tomcat --strip-components=1

# Cambiamos el propietario y los permisos del directorio de instalación
chown -R tomcat:grupoTomcat /opt/tomcat
chmod -R u+x /opt/tomcat/bin

#2. Configuramos los usuarios administradores

# Añadimos roles y usuarios a tomcat-users.xml
sed -i '/<\/tomcat-users>/i \  <role rolename="manager-gui" \/>\n  <user username="manager" password="manager_password" roles="manager-gui" \/>\n  <role rolename="admin-gui" \/>\n  <user username="admin" password="admin_password" roles="manager-gui,admin-gui" \/>' /opt/tomcat/conf/tomcat-users.xml

#Eliminamos la restricciones por defecto

# Comentarmos la etiqueta Valve en context.xml
sed -i '/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/, /allow="127\\.\d+\\.\d+\\.\d+\|::1\|0:0:0:0:0:0:0:1" \/>/ s/^/<!-- /; s/$/ -->/' /opt/tomcat/webapps/manager/META-INF/context.xml

# Comentamos la etiqueta Valve en context.xml de host-manager
sed -i '/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/, /allow="127\\.\d+\\.\d+\\.\d+\|::1\|0:0:0:0:0:0:0:1" \/>/ s/^/<!-- /; s/$/ -->/' /opt/tomcat/webapps/host-manager/META-INF/context.xml

# 3. Creamos el system service
# Crear el archivo tomcat.service y añadir el contenido

sudo bash -c 'cat > /etc/systemd/system/tomcat.service' <<-'EOF'
[Unit]
Description=Tomcat
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Obtener la ruta de instalación de Java 1.17.0
JAVA_PATH=$(sudo update-java-alternatives -l | grep '1.17.0' | awk '{print $3}')

# Reemplazar JAVA_HOME en tomcat.service
sudo sed -i "s|JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64|JAVA_HOME=$JAVA_PATH|g" /etc/systemd/system/tomcat.service

# Recargar servicios systemd y habilitar Apache Tomcat
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat
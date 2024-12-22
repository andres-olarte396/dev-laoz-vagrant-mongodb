#!/bin/bash

# Cargar variables desde el archivo de configuración
CONFIG_FILE="/vagrant/scripts/mongo-config.env"

echo "Leyendo archivo de configuración: $CONFIG_FILE"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
    echo "Usuario: $MONGO_USER"
    echo "Contraseña: $MONGO_PASSWORD"
else
    echo "Error: Archivo de configuración $CONFIG_FILE no encontrado." >&2
    exit 1
fi

if [ -z "$MONGO_USER" ] || [ -z "$MONGO_PASSWORD" ]; then
    echo "Error: Usuario o contraseña no definidos en $CONFIG_FILE." >&2
    exit 1
fi

# Variables
MONGO_VERSION="4.4"
MONGO_CONF="/etc/mongod.conf"
MONGO_REPO="https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/$MONGO_VERSION"

# Verificar que las variables esenciales estén definidas
if [ -z "$MONGO_USER" ] || [ -z "$MONGO_PASSWORD" ]; then
    echo "Error: Usuario o contraseña no definidos en $CONFIG_FILE." >&2
    exit 1
fi

# Actualizar el índice de paquetes
sudo apt update

# Instalar las dependencias necesarias para MongoDB
sudo apt install -y wget gnupg

# Agregar la clave GPG de MongoDB
wget -qO - https://www.mongodb.org/static/pgp/server-$MONGO_VERSION.asc | sudo apt-key add -

# Agregar el repositorio de MongoDB
echo "deb [ arch=amd64,arm64 ] $MONGO_REPO multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-$MONGO_VERSION.list

# Actualizar el índice de paquetes nuevamente
sudo apt update

# Instalar MongoDB
sudo apt install -y mongodb-org

# Habilitar y arrancar el servicio de MongoDB
sudo systemctl enable mongod
sudo systemctl start mongod

# Confirmar la instalación
if ! sudo systemctl is-active --quiet mongod; then
    echo "Error: MongoDB no se está ejecutando" >&2
    exit 1
fi

# Configurar la autenticación en MongoDB
# Modificar el archivo de configuración para habilitar la autorización
sudo sed -i '/^#security:/a \security:\n  authorization: "enabled"' $MONGO_CONF

# Reiniciar el servicio de MongoDB para aplicar cambios
sudo systemctl restart mongod

# Crear el usuario administrador
mongo admin --eval "db.getUser('$MONGO_USER')" | grep -q "$MONGO_USER"
if [ $? -ne 0 ]; then
    mongo admin --eval "
    db.createUser({
        user: '$MONGO_USER',
        pwd: '$MONGO_PASSWORD',
        roles: [{ role: 'userAdminAnyDatabase', db: 'admin' }]
    })"
    echo "Usuario $MONGO_USER creado."
else
    echo "Usuario $MONGO_USER ya existe."
fi

echo "MongoDB instalado, configurado y en ejecución con autenticación habilitada."

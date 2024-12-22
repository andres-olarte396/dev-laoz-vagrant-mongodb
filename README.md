# Proyecto Vagrant con MongoDB

Este proyecto utiliza Vagrant para aprovisionar una máquina virtual Ubuntu con MongoDB preinstalado. Además, se configura un usuario de administrador para la base de datos y se habilita la autenticación para una conexión segura.

## Requisitos

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)

## Instrucciones de configuración

1. **Clonar el repositorio**:

   ```bash
   git clone <URL_DEL_REPOSITORIO>
   cd <NOMBRE_DEL_REPOSITORIO>
   ```

2. **Iniciar la máquina virtual**:

   Ejecuta el siguiente comando para levantar la VM:

   ```bash
   vagrant up
   ```

   Esto instalará MongoDB y configurará la autenticación.

3. **Configurar el acceso a MongoDB**:

   La máquina virtual está configurada para permitir conexiones a MongoDB en `localhost` y solo desde dentro de la VM. La autenticación está habilitada.

4. **Usuario de MongoDB**:

   Durante la instalación, se crea un usuario `admin` con una contraseña que has definido en el script o en las variables de entorno. Este usuario tiene permisos de administrador en la base de datos `admin`.

   - Usuario: `admin`
   - Base de autenticación: `admin`

## Conectarse a MongoDB

### Desde la Máquina Virtual

Para conectarte a MongoDB desde la máquina virtual:

```bash
mongo --port 27017 -u "admin" -p "<CONTRASEÑA>" --authenticationDatabase "admin"
```

### Desde el Host Local (Opcional)

Si deseas conectarte desde el host local, primero asegúrate de que MongoDB esté configurado para aceptar conexiones externas editando el archivo `/etc/mongod.conf` y ajustando el parámetro `bindIp` a `0.0.0.0`. Luego, reinicia el servicio:

```bash
sudo systemctl restart mongod
```

### Cadena de conexión

Usa la siguiente cadena de conexión para aplicaciones externas:

```plaintext
mongodb://admin:<CONTRASEÑA>@localhost:27017/admin
```

Reemplaza `<CONTRASEÑA>` con la contraseña del usuario `admin`.

## Configuración de seguridad

Para un entorno de producción, considera restringir el acceso remoto solo a IPs confiables y asegurarte de que el puerto `27017` esté protegido en el firewall.

## Detener la Máquina Virtual

Para detener la VM:

```bash
vagrant halt
```

## Destruir la Máquina Virtual

Para destruir la VM y borrar todos los datos:

```bash
vagrant destroy
```

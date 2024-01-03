## Descargamos ubuntu
FROM ubuntu

## Actualizamos el sistema
RUN apt-get update

## En algunas versiones de linux es necesario configurar una variable para el TIMEZONE
ENV TZ=America/Buenos_Aires

## Luego creamos un fichero llamado /etc/timezone y le agregamos el valor de la variable TZ
RUN echo $TZ > /etc/timezone

## Instalamos NGINX
RUN apt-get install -y nginx

## Creamos un fichero index.html en la carpeta /var/www/html
RUN echo "<h1>Ejemplo de POD con Kubernetes y YAML</h1>" > /var/www/html/index.html

## Iniciamos NGINX a través del ENTRYPOINT para que no pueda ser modificado en la creación del contenedor
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]

## Exponemos el puerto 80
EXPOSE 80



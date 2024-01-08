# ```POD``` - Kubernetes

## Indice
- [Que es un ```POD```?](#que-es-un-pod)
- [Que caracteristicas me da un ```POD```](#que-caracteristicas-me-da-un-pod)
- [Como se define un ```POD```](#como-se-define-un-pod)
  - [Metodo imperativo](#metodo-imperativo)
  - [Metodo declarativo](#metodo-declarativo)
- [Como se ejecuta un ```POD```](#como-se-ejecuta-un-pod)
- [Como se listan los ```POD```](#como-se-listan-los-pod)
- [Comando ```describe```](#comando-describe)
- [Lanzar comandos dentro de un ```POD```](#lanzar-comandos-dentro-de-un-pod)
  - [Ejemplo: Pod en apache](#ejemplo-pod-en-apache)
- [Como eliminar un ```POD```](#como-eliminar-un-pod)
- [Kubectl Proxy](#kubectl-proxy)
- [Acceder a los pods desde afuera](#acceder-a-los-pods-desde-afuera)
  - [Exponer servicios](#exponer-servicios)
  - [Port Forwarding](#port-forwarding)
- [POD declarativos](#pod-declarativos)
    - [Crear un pod ```create```](#crear-un-pod-create)
- [Obtener toda la configuracion de un pod](#obtener-toda-la-configuracion-de-un-pod)
- [Borrar un ```POD```](#borrar-un-pod)
- [Pod con multiples contenedores](#pod-con-multiples-contenedores)
- [Utilizar ```apply``` para actualizar un pod](#utilizar-apply-para-actualizar-un-pod)
- [Politicas de reinicio](#politicas-de-reinicio)
- [Prueba de politicas de reinicio](#prueba-de-politicas-de-reinicio)
  - [Restart Always](#restart-always)
  - [Restart OnFailure](#restart-onfailure)
  - [Restart Never](#restart-never)
- [Etiquetas](#etiquetas)
  - [Agregar etiquetas a un pod](#agregar-etiquetas-a-un-pod)
  - [Ver etiquetas de un pod](#ver-etiquetas-de-un-pod)
  - [Agregar etiquetas a un pod existente en modo imperativo ```(-L)```](#agregar-etiquetas-a-un-pod-existente-en-modo-imperativo)
  - [Eliminar etiquetas a un pod existente en modo imperativo ```(-)```](#eliminar-etiquetas-a-un-pod-existente-en-modo-imperativo--)
  - [Agregar etiquetas a un pod existente en modo declarativo ](#agregar-etiquetas-a-un-pod-existente-en-modo-declarativo)
  - [Eliminar etiquetas a un pod existente en modo declarativo](#eliminar-etiquetas-a-un-pod-existente-en-modo-declarativo)
- [Selectores](#selectores)
  - [Listar pods por etiqueta (```-l```)](#selecionar-pods-por-etiqueta)
  - [Listar pods por etiqueta con operadores](#selecionar-pods-por-etiqueta-con-operadores)

## Que es un ```POD```?

Se puede considerar un ```POD``` como un envoltorio que tiene una serie de propiedades comunes con las que gobierna sus contenedores. Es decir, un ```POD``` es un grupo de uno o mas contenedores que comparten almacenamiento y una unica direccion IP.

> Los ```pod``` se ejecutan dentro de un ```nodo```, y un nodo puede tener varios pod pero no es lo recomendable, ya que por ejemplo si tengo un pod con un ```apache``` y un ```mysql``` deberia apagar el pod para poder actualizar el ```apache```, y si apago el pod se apaga el ```mysql```, por lo que no es lo recomendable. Otras implicancias pueden ser el ciclo de vida de cada contenedor puede ser diferente ademas tengo que considerar el backup de cada contenedor, etc.


## Que caracteristicas me da un ```POD```

Cada POD tiene su propia IP con la cual se pueden comunicar entre si, y tambien se puede acceder a ellos desde el exterior. Y las caracteristicas que nos da un POD son:

- Direcciones
- Puertos
- hostnames
- Sockets
- Memoria
- Volumenes
- Etc

Por defecto los pods no tienen estado, es decir, si se cae el pod, se pierde la informacion que tenia, por lo que se necesita un volumen para que los datos persistan.

## Como se define un ```POD```

### Metodo imperativo

```bash
kubectl run <nombre_pod> --image=<imagen> --port=<puerto>
```
ejemplo:

```bash
kubectl run nginx1 --image=nginx --port=80
```

### Metodo declarativo

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: <nombre_pod>
spec:
    containers:
    - name: <nombre_contenedor>
        image: <imagen>
        ports:
        - containerPort: <puerto>
```

## Comando ```apply```
> Sirve para aplicar un archivo de tipo ```manifest``` (yaml o json)

```bash
kubectl apply -f <nombre_archivo>.yaml
```

## Como se listan los ```POD```

```bash
# Para ver los pods
kubectl get pods

# Para ver mas informacion
kubectl get pods -o wide
```

## Comando ```describe```

Sirve para ver mas informacion de un pod en particular

```bash
kubectl describe pod <nombre_pod>
```

## Lanzar comandos dentro de un ```POD```

```bash
kubectl exec <nombre_pod> -- <comando>
```
ejemplo:

```bash
# Para ver los archivos dentro del pod
kubectl exec nginx1 -- ls -l

# Para ver el contenido de un archivo dentro del pod
kubectl exec nginx1 -- cat /etc/nginx/nginx.conf

# Para ejecutar un comando dentro del pod
kubectl exec nginx1 -- nginx -v

kubectl exec nginx1 -- uname -a  

```

> Para entrar en modo interactivo se usa ```-it``` y para salir ```exit```
```bash
kubectl exec -it nginx1 -- bash
```

### Ejemplo: Pod en apache
    
```bash
# Para crear el pod
kubectl run apache --image=httpd --port=8080

# Para ver log del pod
kubectl logs apache

# Para ver log del pod en tiempo real
kubectl logs -f apache

# Para ver las ultimas 10 lineas del log del pod
kubectl logs --tail=10 apache
```

## Como eliminar un ```POD```

```bash
kubectl delete pod <nombre_pod>

# Ejemplo
kubectl delete pod nginx1
```

## Kubectl Proxy

El proxy tiene la habilidad de exponer los servicios del cluster y acceder al recurso que queremos.
    
```bash
kubectl proxy
```
> Para acceder a un pod se usa ```http://localhost:8001/api/v1/namespaces/default/pods/<nombre_pod>```

## Acceder a los pods desde afuera
    
### Exponer servicios
```bash
# Para exponer un pod
kubectl expose pod <nombre_pod> --port=<puerto> --name=<nombre_servicio> --type=<tipo_servicio>
```

- ```--port```: puerto del servicio
- ```--name```: nombre del servicio
- ```--type```: tipo de servicio (ClusterIP, NodePort, LoadBalancer, ExternalName)

> Para ver los servicios se usa ```kubectl get services``` o ```kubectl get svc```

### Port Forwarding
Se utiliza para acceder a un pod desde el exterior indicando el puerto local y el puerto del pod

```bash
kubectl port-forward <nombre_pod> <puerto_local>:<puerto_pod>
```

## POD declarativos
Para crear un pod con un fichero de tipo ```manifest``` se usa el siguiente formato:

```yaml
# nombre_archivo.yaml -> nginx.yaml

apiVersion: v1 # version de la api
kind: Pod # tipo de recurso
metadata: # metadatos del recurso
  name: nginx # nombre del recurso
  labels: # etiquetas del recurso
    name: nginx
    zone: prod
    version: v1
spec: # especificaciones del recurso
  containers: # contenedores del recurso
  - name: nginx # nombre del contenedor
    image: nginx:latest # imagen del contenedor
    resources: # recursos del contenedor
      limits: # limites del contenedor
        memory: "128Mi" # memoria maxima
        cpu: "500m" # cpu maxima
    ports: # puertos del contenedor
      - containerPort: 80 # puerto del contenedor
        protocol: TCP # protocolo del puerto
```

### Crear un pod ```create```

```bash
kubectl create -f <nombre_archivo>.yaml

# Ejemplo
kubectl create -f nginx.yaml

#Creo un servicio para el pod
kubectl expose pod nginx --port=80 --name=nginx-svc --type=LoadBalancer
```

## Obtener toda la configuracion de un pod

```bash
kubectl get pod <nombre_pod> -o yaml

# Ejemplo

#yaml
kubectl get pod nginx -o yaml
# en un archivo
kubectl get pod nginx -o yaml > nginx-conf.yaml

#json
kubectl get pod nginx -o json
# en un archivo
kubectl get pod nginx -o json > nginx-conf.json
```

## Borrar un ```POD```

```bash
# Borrar un pod
kubectl delete pod <nombre_pod>

# periodo de gracia (5 segundos )
kubectl delete pod <nombre_pod> --grace-period=5

# Borrar forzado
kubectl delete pod <nombre_pod> --force

# Borrar ahora y no esperar a que se termine de ejecutar
kubectl delete pod <nombre_pod> --now

# Borrar todos los pods
kubectl delete pod --all
```

## Pod con multiples contenedores

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: <nombre_pod>
spec:
    containers:
    - name: <nombre_contenedor1>
        image: <imagen1>
        ports:
        - containerPort: <puerto1>
    - name: <nombre_contenedor2>
        image: <imagen2>
        ports:
        - containerPort: <puerto2>
```

> Los contenedores se ejecutan en el mismo nodo, por lo que comparten la misma IP y el mismo volumen.

> Los contenedores se ejecutan en el mismo ciclo de vida, es decir, si se cae el pod se caen todos los contenedores.

> Los contenedores se ejecutan en el mismo espacio de nombres, por lo que pueden acceder a los mismos recursos.

> Los contenedores se ejecutan en el mismo volumen, por lo que comparten la misma informacion.

### Ejemplo: Pod con multiples contenedores

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: multi
spec:
  containers:
  - name: web
    image: nginx
    ports:
    - containerPort: 80  
  - name: frontal
    image: alpine
    command: ["watch", "-n5", "ping",  "localhost"]
```
## Utilizar ```apply``` para actualizar un pod
> diferencia entre ```apply``` y ```create``` es que ```apply``` se usa para actualizar un pod, mientras que ```create``` se usa para crear un pod. Si modifico el archivo y utilizo ```create``` me va a dar error, mientras que si utilizo ```apply``` me va a actualizar el pod.

```bash
kubectl apply -f <nombre_archivo>.yaml

# Ejemplo
kubectl apply -f multi.yaml
```
> Para ver los logs de un contenedor en particular se usa ```kubectl logs <nombre_pod> -c <nombre_contenedor>```

```bash
kubectl logs multi -c web # logs del contenedor web
kubectl logs multi -c frontal # logs del contenedor frontal

# -f para ver los logs en tiempo real
kubectl logs -f multi -c frontal

# Para ver los logs de todos los contenedores
kubectl logs multi --all-containers
```
## Politicas de reinicio

- ```Always```: Siempre se reinicia el pod (por defecto)
- ```Never```: Nunca se reinicia el pod 
- ```OnFailure```: Se reinicia el pod si falla

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: <nombre_pod>
spec:
  restartPolicy: <politica_reinicio>
  containers:
  - name: <nombre_contenedor>
    image: <imagen>
    ports:
    - containerPort: <puerto>
```
## Prueba de politicas de reinicio

### Restart Always
```bash
# Creo un pod con politica de reinicio Always (tomcat)
kubectl apply -f .\restart-always.yaml 

# Ingreso al bash del pod
kubectl exec -it tomcat -- bash
```
```
# veo los procesos del pod
ps -ef 
```

| UID  | PID | PPID | C | STIME | TTY   | TIME       | CMD                                                                                                    |
|------|-----|------|---|-------|-------|------------|--------------------------------------------------------------------------------------------------------|
| root | 1   | 0    | 2 | 00:45 | ?     | 00:00:02   | /opt/java/openjdk/bin/java -Djava.util.logging.config.file=/usr/local/tomcat/conf/logging.properties -Djava.util.logg |
| root | 38  | 0    | 0 | 00:47 | pts/0 | 00:00:00   | bash                                                                                                   |
| root | 46  | 38   | 0 | 00:47 | pts/0 | 00:00:00   | ps -ef 

```bash
# Detengo el servicio de tomcat
catalina.sh stop
------------------------------------------------
Using CATALINA_BASE:   /usr/local/tomcat
Using CATALINA_HOME:   /usr/local/tomcat
Using CATALINA_TMPDIR: /usr/local/tomcat/temp
Using JRE_HOME:        /opt/java/openjdk
Using CLASSPATH:       /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar
Using CATALINA_OPTS:
command terminated with exit code 137
```

```bash
# Describo el pod
kubectl describe pod tomcat

# Veo que el Restart Count es 1
Restart Count:  1

# Veo que el pod se reinicio
kubectl get pod tomcat                                             

# Muestra lo siguiente
NAME     READY   STATUS    RESTARTS        AGE
tomcat   1/1     Running   1 (4m18s ago)   13m
```

### Restart OnFailure

```bash
# borro el pod anterior
kubectl delete pod tomcat

# Creo un pod con politica de reinicio OnFailure (tomcat)
kubectl apply -f .\restart-onfailure.yaml

# veo los logs del pod
kubectl logs on-failure
```


```bash
# Describo el pod
kubectl describe pod on-failure

Events:
  Type     Reason     Age                     From               Message
  ----     ------     ----                    ----               -------
  Normal   Scheduled  9m33s                   default-scheduler  Successfully assigned default/on-failure to docker-desktop
  Normal   Pulled     9m29s                   kubelet            Successfully pulled image "busybox" in 4.029s (4.029s including waiting)
  Normal   Pulled     9m27s                   kubelet            Successfully pulled image "busybox" in 1.789s (1.789s including waiting)
  Normal   Pulled     9m11s                   kubelet            Successfully pulled image "busybox" in 1.741s (1.741s including waiting)
  Normal   Created    8m41s (x4 over 9m29s)   kubelet            Created container on-failure
  Normal   Started    8m41s (x4 over 9m29s)   kubelet            Started container on-failure
  Normal   Pulled     8m41s                   kubelet            Successfully pulled image "busybox" in 1.958s (1.958s including waiting)
  Normal   Pulling    7m55s (x5 over 9m33s)   kubelet            Pulling image "busybox"
  Warning  BackOff    4m29s (x25 over 9m27s)  kubelet            Back-off restarting failed container on-failure in 
                                                                 pod on-failure_default(7f820439-2ca4-420b-9f53-bad7e39240f6)

# Veo que el Restart Count es 16
kubectl get pods                                                                                                                                                                                                                                                                                                          
NAME         READY   STATUS             RESTARTS         AGE                                                                                                                     
on-failure   0/1     CrashLoopBackOff   16 (3m36s ago)   61m
```

### Restart Never

```bash
# borro el pod anterior
kubectl delete pod on-failure

# Creo un pod con politica de reinicio Never
kubectl apply -f .\restart-never.yaml

# veo los logs del pod
kubectl logs never
Ejemplo de pod fallado

# Reviso el estado del pod
kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE                                  
never   0/1     Error     0         73s                       
```           

## Etiquetas

Las etiquetas son pares clave-valor que se pueden agregar a los recursos de Kubernetes, como pods, para identificarlos y organizarlos. Las etiquetas se pueden usar para seleccionar y filtrar recursos cuando se realiza una operación en un grupo de recursos. Por ejemplo, puede usar etiquetas para seleccionar todos los pods con una etiqueta de entorno de producción o todos los pods con una etiqueta de entorno de prueba.

> Pueden empezar con letras, numeros y guiones, pueden tener hasta 63 caracteres y no admiten espacios en blanco y otros caracteres raros.

### Agregar etiquetas a un pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: tomcat
  labels:
    estado: "desarrollo" # etiqueta
spec:
  containers:
   - name: tomcat
     image: tomcat
```

### Ver etiquetas de un pod
```bash
# Creo el pod
kubectl apply -f ./pods/tomcat.yaml

# Veo los pods con sus etiquetas
kubectl get pods --show-labels

NAME         READY   STATUS    RESTARTS         AGE    LABELS
never        0/1     Error     0                133m app=app1
on-failure   0/1     Error     29 (5m16s ago)   123m   app=app1
tomcat       1/1     Running   0                4m7s   estado=desarrollo # muestra la etiqueta estado


# Veo los pods con la etiqueta -L y el nombre de la etiqueta para que la muestre en una nueva columna
kubectl get pods --show-labels -L estado

NAME         READY   STATUS             RESTARTS        AGE     ESTADO       LABELS
never        0/1     Error              0               133m                 app=app1
on-failure   0/1     CrashLoopBackOff   28 (5m3s ago)   123m                 app=app1
tomcat       1/1     Running            0               3m54s   desarrollo   estado=desarrollo # muestra la etiqueta estado
```
                                              
### Agregar etiquetas a un pod existente en modo imperativo

```bash
# Agrego la etiqueta
kubectl label pod <nombre_pod> <nombre_etiqueta>=<valor_etiqueta>
# Sobreescribir etiqueta existente (--overwrite)
kubectl label pod <nombre_pod> <nombre_etiqueta>=<valor_etiqueta> --overwrite
# Ejemplo
kubectl label pod tomcat responsable=Juan
kubectl label pod tomcat estado=produccion --overwrite # --overwrite para sobreescribir la etiqueta


# Veo los pods con sus etiquetas
kubectl get pods --show-labels
---------------------------------------------------------------------------------------------------
NAME         READY   STATUS             RESTARTS         AGE    LABELS
never        0/1     Error              0                142m   app=app1
on-failure   0/1     CrashLoopBackOff   30 (4m15s ago)   133m   app=app1
tomcat       1/1     Running            0                13m    estado=produccion,responsable=Juan

# Veo los pods con la etiqueta -L y el nombre de la etiqueta para que la muestre en una nueva columna
kubectl get pods --show-labels -L estado,responsable
---------------------------------------------------------------------------------------------------
NAME         READY   STATUS             RESTARTS       AGE    ESTADO       RESPONSABLE   LABELS
never        0/1     Error              0              145m                              app=app1
on-failure   0/1     CrashLoopBackOff   31 (90s ago)   135m                              app=app1
tomcat       1/1     Running            0              15m    produccion   Juan          estado=produccion,responsable=Juan

```

### Eliminar etiquetas a un pod existente en modo imperativo (-)

```bash
# Elimino la etiqueta
kubectl label pod <nombre_pod> <nombre_etiqueta>-

# Ejemplo
kubectl label pod tomcat responsable- # elimina la etiqueta responsable
kubectl label pod tomcat estado- # elimina la etiqueta estado
```	

> Es mejor usar el modo declarativo para agregar etiquetas

### Agregar etiquetas a un pod existente en modo declarativo

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: tomcat
  labels:
    estado: "desarrollo" # etiqueta
    responsable: "Juan" # etiqueta agregada
spec:
  containers:
   - name: tomcat
     image: tomcat
```
```bash
# Aplico el archivo
kubectl apply -f ./pods/tomcat.yaml

# Veo los pods con sus etiquetas
kubectl get pods --show-labels
```
### Eliminar etiquetas a un pod existente en modo declarativo

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: tomcat
  labels:
    estado: "desarrollo" # etiqueta
spec:
  containers:
   - name: tomcat
     image: tomcat
```

```bash
# Aplico el archivo
kubectl apply -f ./pods/tomcat.yaml

# Veo los pods con sus etiquetas
kubectl get pods --show-labels

```

## Selectores

Los selectores son una forma de filtrar los recursos de Kubernetes. Los selectores se pueden usar para seleccionar y filtrar recursos cuando se realiza una operación en un grupo de recursos. Por ejemplo, puede usar selectores para seleccionar todos los pods con una etiqueta de entorno de producción o todos los pods con una etiqueta de entorno de prueba.

> utilizaremos los ficheros de la carpeta labels

1. Inicializamos todos los pods
```bash
# Ingresamos al directorio labels
cd labels

# Inicializamos todos los pods
kubectl apply -f .

# Listamos los pods con sus etiquetas
kubectl get pods --show-labels

NAME      READY   STATUS    RESTARTS   AGE   LABELS
tomcat    1/1     Running   0          60s   estado=desarrollo,responsable=juan
tomcat1   1/1     Running   0          60s   estado=desarrollo,responsable=juan
tomcat2   1/1     Running   0          60s   estado=testing,responsable=pedro
tomcat3   1/1     Running   0          60s   estado=produccion,responsable=pedro

```

### Selecionar pods por etiqueta



- ```= o ==``` son lo mismo y significa es igual a ```estado=desarrollo```
- ```!=``` es distinto a ```estado!=desarrollo```
- ```in``` es igual a ```estado in (desarrollo,testing)``` 
- ```notin``` es distinto a ```estado notin (desarrollo,testing)```
- ```!``` es distinto a ```!estado```
- ```,``` se usa para separar etiquetas ```estado=desarrollo,responsable=juan``` como si fuera un ```AND```

```bash
# Seleccionamos los pods con estado=desarrollo
kubectl get pods --show-labels -l estado=desarrollo
NAME      READY   STATUS    RESTARTS   AGE     LABELS
tomcat    1/1     Running   0          6m31s   estado=desarrollo,responsable=juan
tomcat1   1/1     Running   0          6m31s   estado=desarrollo,responsable=juan    

# Seleccionamos los pods con estado=testing
kubectl get pods --show-labels -l estado=testing

NAME      READY   STATUS    RESTARTS   AGE     LABELS
tomcat2   1/1     Running   0          7m17s   estado=testing,responsable=pedro

# Seleccionamos los pods con estado=produccion
kubectl get pods --show-labels -l estado=produccion

NAME      READY   STATUS    RESTARTS   AGE     LABELS
tomcat3   1/1     Running   0          7m52s   estado=produccion,responsable=pedro
```

### Selecionar pods por etiqueta con operadores

```bash
# Seleccionamos los pods con estado=desarrollo o testing
kubectl get pods --show-labels -l 'estado in (desarrollo,testing)'

NAME      READY   STATUS    RESTARTS   AGE   LABELS
tomcat    1/1     Running   0          13m   estado=desarrollo,responsable=juan
tomcat1   1/1     Running   0          13m   estado=desarrollo,responsable=juan
tomcat2   1/1     Running   0          13m   estado=testing,responsable=pedro

# Seleccionamos los pods con estado=desarrollo o testing
kubectl get pods --show-labels -l 'estado notin (desarrollo,testing)'

NAME      READY   STATUS    RESTARTS   AGE   LABELS
tomcat3   1/1     Running   0          14m   estado=produccion,responsable=pedro

# Seleccionamos los pods con estado=desarrollo y responsable=juan
kubectl get pods --show-labels -l 'estado=desarrollo,responsable=juan'

NAME     READY   STATUS    RESTARTS   AGE   LABELS
tomcat    1/1     Running   0         15m   estado=desarrollo,responsable=juan
tomcat1   1/1     Running   0         15m   estado=desarrollo,responsable=juan

# Seleccionamos los pods con estado=desarrollo y responsable=pedro
kubectl get pods --show-labels -l 'estado=desarrollo,responsable=pedro'

No resources found in default namespace.

# Seleccionamos donde el responsable no sea juan

kubectl get pods --show-labels -l 'responsable!=juan'

NAME      READY   STATUS    RESTARTS   AGE   LABELS
tomcat2   1/1     Running   0          16m   estado=testing,responsable=pedro
tomcat3   1/1     Running   0          16m   estado=produccion,responsable=pedro

# Borro todos los pods que están en desarrollo
kubectl delete pods -l 'estado=desarrollo'

pod "tomcat" deleted                                         
pod "tomcat1" deleted 

```

## Anotaciones

Las anotaciones son pares clave-valor que se pueden agregar a los recursos de Kubernetes, como pods, para identificarlos y organizarlos. Las anotaciones se pueden usar para seleccionar y filtrar recursos cuando se realiza una operación en un grupo de recursos. Por ejemplo, puede usar anotaciones para seleccionar todos los pods con una etiqueta de entorno de producción o todos los pods con una etiqueta de entorno de prueba.

> Estas anotaciones nos permiten darle algún sentido o alguna descripción a nuestros pods.

### Agregar anotaciones a un pod (declarativo)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: tomcat
  labels:
    estado: "desarrollo" # etiqueta
  annotations:
    doc: "Se debe compilar con gcc" # anotacion
    adjunto: "ejemplo de anotación" # anotacion
spec:
  containers:
   - name: tomcat
     image: tomcat
```

```bash
# Aplico el archivo
kubectl apply -f ./pods/tomcat.yaml

kubectl get pods tomcat4

NAME      READY   STATUS    RESTARTS   AGE
tomcat4   1/1     Running   0          52s 

# Veo las anotaciones
kubectl describe pod tomcat4

# Busco la seccion de annotations
kubectl get pod tomcat4 -o 'jsonpath={.metadata.annotations}'

{"adjunto":"ejemplo de anotacion","doc":"Se debe compilar con gcc","kubectl.kubernetes.io/last-applied-configuration":"{\"apiVersion\":\"v1\",\"kind\":\"Pod\",\"metadata\":{\"annotations\":{\"adjunto\":\"ejemplo de anotacion\",\"doc\":\"Se debe compilar con gcc\"},\"labels\":{\"estado\":\"produccion\",\"responsable\":\"pedro\"},\"name\":\"tomcat4\",\"namespace\":\"default\"},\"spec\":{\"containers\":[{\"image\":\"tomcat\",\"name\":\"tomcat\"}]}}\n"}

```

# Deployments

El deployment es un componente que va a orquestar el despliegue de los pods, es decir, va a ser el encargado de crear los pods, actualizarlos, eliminarlos. Manejando las replicas, las recuperaciones ante catastrofes, escalar, configurar recursos, etc.

## Workloads y controllers

- Workloads: El workload se utiliza para poder correr contenedores en Kubernetes y se encargan de correr los procesos.
Nuestro workload mas básico son los ```pods``` pero estos, no tienen caracteristicas que necesitamos en un cluster como por ejemplo la cantidad de replicas, el escalamiento, la recuperacion ante catastrofes, la capacidad de hacer updates y rollbacks de manera sencilla. Para poder tener estas caracteristicas en nuestro cluster necesitamos tener otros objetos.

  - ```Deployment```: Son los componentes que van a envolver a los pods y van a ser los encargados de crearlos, actualizarlos, eliminarlos, etc.
  - ```ReplicaSet```: Son los encargados de mantener la cantidad de replicas que nosotros definimos en el deployment. (en algunas documentaciones tambien se pueden mencionar como replication controller)
  - ```StatefulSet```: Gestiona el despliegue y el escalado y garantiza el orden y la unicidad de los pods.
  - ```DaemonSet```: Son los encargados de asegurar que todos los nodos del cluster tengan una copia del pod que nosotros definimos.
  - ```Job```: Son los encargados de ejecutar un pod y asegurarse que se ejecute una sola vez.
  - ```CronJob```: Son los encargados de ejecutar un pod en un horario especifico.

  > A grandes rasgos los ```workloads``` terminan siendo envolturas que van a tener uno o mas pods y van a permitir que se ejecuten de una determinada manera.

- Controllers: Los controllers son los encargados de controlar que los workloads se ejecuten de la manera que nosotros definimos.

> Los pods no escalan, no se recuperan ante caidas, y ademas cuando quiero actualizar la aplicación o hacer un rollback no puedo hacerlo de manera sencilla. Por lo que necesito un objeto que me permita hacer todo esto, y ese objeto es el ```deployment``` por lo que no se trabaja de forma directa con ```pods```sino que utilizaremos directamente ```deploymets```.

## Que es un ```Deployment```?

Un ```deployment``` es un objeto que nos permite definir como se van a ejecutar los pods, es decir, nos permite definir la cantidad de replicas, la estrategia de actualizacion, la recuperacion ante catastrofes, etc.

> Los ```deployments``` son objetos de tipo ```workload``` y son los encargados de crear los pods, actualizarlos, eliminarlos, etc.

## Como creo un ```Deployment``` de modo imperativo?

```bash
kubectl create deployment <nombre_deployment> --image=<imagen>

# Ejemplo
kubectl create deployment apache --image=httpd
```

## Como se define un ```Deployment```?

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: <nombre_deployment>
spec: # estado ideal de mi deployment
  replicas: <cantidad_replicas>
  selector:
    matchLabels:
      <nombre_etiqueta>: <valor_etiqueta>
  template:
    metadata:
      labels:
        <nombre_etiqueta>: <valor_etiqueta>
    spec:
      containers:
      - name: <nombre_contenedor>
        image: <imagen>
        ports:
        - containerPort: <puerto>
```
> Los ```deployments``` son la unidad de trabajo mas habitual y mas adecuada para desplegar aplicaciones en Kubernetes.

> Cuando yo creo un deployment, el deployment va a crear un ```replicaset``` y el ```replicaset``` va a crear los pods.


## Como se ejecuta un ```Deployment```?

```yaml
# deploy_nginx.yaml

apiVersion: apps/v1 # i se Usa apps/v1beta2 para versiones anteriores a 1.9.0
kind: Deployment
metadata:
  name: nginx-d
  labels:
    app: nginx
spec:
  selector:   #permite seleccionar un conjunto de objetos que cumplan las condicione
    matchLabels:
      app: nginx
  replicas: 2 # indica al controlador que ejecute 2 pods
  template:   # Plantilla que define los containers
    metadata:
      labels:
        app: nginx
    spec:    # Especifica las caracteristicas de los containers es igual a la especificacion de un pod
      containers:
      - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 80
```

```bash
# Para crear el deployment desde el archivo
# con apply se almacena en el etcd y rapidamente se crea el replicaset y los pods
kubectl apply -f <nombre_archivo>.yaml

# Ejemplo

# Me muevo al directorio deployments
cd deployments


# Creo el deployment
kubectl apply -f deploy_nginx.yaml
```

## Como se listan los ```Deployments```?

```bash
# Para ver los deployments
kubectl get deployments

# Para ver mas informacion
kubectl get deployments -o wide

# Para ver los pods de un deployment
kubectl get pods -l app=nginx

NAME                     READY   STATUS    RESTARTS   AGE
nginx-d-9d6cbcc65-h8l7h   1/1     Running   0         5m23s
nginx-d-9d6cbcc65-r2lhk   1/1     Running   0         5m23s


# Para pods, deployments y replicasets en una sola linea
kubectl get deploy,pods,rs -l app=nginx

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE       
deployment.apps/nginx-d   2/2     2            2           13m

NAME                          READY   STATUS    RESTARTS   AGE
pod/nginx-d-9d6cbcc65-h8l7h   1/1     Running   0          13m
pod/nginx-d-9d6cbcc65-r2lhk   1/1     Running   0          13m

NAME                                DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-d-9d6cbcc65   2         2         2       13m
```

### Comando ```edit```


> El comando edit nos permite configurar y actualizar un deployment de manera dinamica sin necesidad de tener el fichero original y volverlo a aplicar.

```bash
# Para editar un deployment
kubectl edit deployment <nombre_deployment>

# Ejemplo
kubectl edit deployment nginx-d

# Se abre el archivo en el editor de texto

```
> Cuando cierro el fichero de texto el deployment se actualiza si tiene cambios

### Comando ```scale```

> El comando scale nos permite escalar un deployment de manera dinamica sin necesidad de tener el fichero original y volverlo a aplicar.


```bash
# Para escalar un deployment
kubectl scale deployment <nombre_deployment> --replicas=<cantidad_replicas>

# Ejemplo
kubectl scale deployment nginx-d --replicas=3

# Para ver los pods de un deployment
kubectl get deploy,pods,rs -l app=nginx

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-d   3/3     3            3           27m

NAME                          READY   STATUS    RESTARTS   AGE
pod/nginx-d-9d6cbcc65-h8l7h   1/1     Running   0          27m
pod/nginx-d-9d6cbcc65-pbscn   1/1     Running   0          5m45s
pod/nginx-d-9d6cbcc65-r2lhk   1/1     Running   0          27m

NAME                                DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-d-9d6cbcc65   3         3         3       27m

# Escalo un deployment a 10 replicas filtrando por etiqueta
kubectl scale deployment -l app=nginx --replicas=10

# Para ver los pods de un deployment
kubectl get deploy,pods,rs -l app=nginx

# Muestra lo siguiente
kubectl get deploy,pods,rs -l app=nginx

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-d   10/10   10           10          4h12m       
NAME                          READY   STATUS    RESTARTS   AGE
pod/nginx-d-9d6cbcc65-5jdq7   1/1     Running   0          23s
pod/nginx-d-9d6cbcc65-9zlg6   1/1     Running   0          23s
pod/nginx-d-9d6cbcc65-dqgtb   1/1     Running   0          23s
pod/nginx-d-9d6cbcc65-dspv7   1/1     Running   0          23s
pod/nginx-d-9d6cbcc65-gpb7l   1/1     Running   0          23s
pod/nginx-d-9d6cbcc65-h8l7h   1/1     Running   0          4h12m
pod/nginx-d-9d6cbcc65-l7279   1/1     Running   0          23s
pod/nginx-d-9d6cbcc65-pbscn   1/1     Running   0          3h50m
pod/nginx-d-9d6cbcc65-r2lhk   1/1     Running   0          4h12m
pod/nginx-d-9d6cbcc65-rkrvd   1/1     Running   0          23s

NAME                                DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-d-9d6cbcc65   10        10        10      4h12m
```


## Servicios

Los servicios son objetos que nos permiten exponer los pods de manera interna o externa. Los servicios son la forma de comunicarnos con los pods. Este tipo de objeto se encuentra entre el cliente y el pod.

> Los servicios son objetos de tipo ```service``` y son los encargados de exponer los pods.

>Los ```deployments``` no tienen una ```ip fija```, no tienen un nombre ```dns fijo``` y no tienen tampoco un ```puerto fijo```. Y en el momento que se cae un ```pod``` y el ```replicaSet``` crea uno nuevo, este le **asigna una nueva ip** por lo que manejar toda esa estructura de manera directa es imposible sin un ```service```.

### Propiedades que ofrecen los servicios

- ```IP fija```: Los servicios nos permiten tener una ip fija para poder comunicarnos con los pods.
- ```DNS fijo```: Los servicios nos permiten tener un nombre dns fijo para poder comunicarnos con los pods.
- ```Puerto fijo```: Los servicios nos permiten tener un puerto fijo para poder comunicarnos con los pods.
- ```Balanceo de carga```: Los servicios nos permiten tener un balanceo de carga para poder comunicarnos con los pods.
- ```Descubrimiento de servicios```: Los servicios nos permiten tener un descubrimiento de servicios para poder comunicarnos con los pods.

### Tipos de servicios

- ```ClusterIP```: Los servicios de tipo ```ClusterIP``` nos permiten **exponer los pods de manera interna**, es decir, **solo dentro del cluster**. Este tipo de servicio es el que se utiliza por defecto.
- ```NodePort```: Los servicios de tipo ```NodePort``` nos permiten **exponer los pods de manera externa**, es decir, **desde fuera del cluster**. Este tipo de servicio es el que se utiliza para poder acceder a los pods desde el exterior.
- ```LoadBalancer```: Los servicios de tipo ```LoadBalancer``` nos permiten exponer los pods de manera externa, al igual que el ```NodePort```, pero sirve para conectarse a los diferentes servicios que existen en el cloud. Como por ejemplo aws, azure, gcp, etc.

### Como se define un ```Service```?

```yaml
apiVersion: v1
kind: Service
metadata:
  name: <nombre_service>
spec:
  type: <tipo_service>
  selector:
    <nombre_etiqueta>: <valor_etiqueta>
  ports:
  - protocol: TCP
    port: <puerto>
    targetPort: <puerto>
```
> El ```selector``` es el que va a permitir que el servicio sepa a que pods tiene que apuntar.

### Crear un servicio de manera imperativa

```bash
# Crear un servicio de tipo ClusterIP
kubectl expose deployment <nombre_deployment> --port=<puerto> --target-port=<puerto>

# Ejemplo

# Creo un deployment
kubectl create deployment apache1 --image=httpd
deployment.apps/apaceh1 created  

kubectl expose deployment apache --port=80 --type=NodePort
service/apache exposed  






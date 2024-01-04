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
- [Utilizar apply para actualizar un pod](#utilizar-apply-para-actualizar-un-pod)


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

## Como se ejecuta un ```POD```

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
## Utilizar apply para actualizar un pod
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

- ```Never```: Nunca se reinicia el pod (por defecto)
- ```Always```: Siempre se reinicia el pod
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


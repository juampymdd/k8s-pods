# ```POD``` - Kubernetes

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

## Acceder a los pods
    
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


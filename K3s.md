# K3s

K3s es una distribución ligera de Kubernetes diseñada para instalarse fácilmente en sistemas con recursos limitados, como máquinas virtuales o dispositivos IoT. Aquí te proporcionaré una guía básica para instalar K3s en un sistema basado en Linux.

## Instalación de K3s:
Descargar e instalar K3s:

```bash
curl -sfL https://get.k3s.io | sh -
```
Este comando descargará e instalará K3s en tu sistema.

Verificar el estado de K3s:

Después de la instalación, puedes verificar el estado de K3s ejecutando:

```bash
sudo k3s kubectl get nodes
```

Esto debería mostrar el nodo en el que se instaló K3s.

## Configurar kubectl:

K3s incluye su propia versión de kubectl. Puedes configurar tu entorno local para usar la versión de kubectl proporcionada por K3s ejecutando:

```bash
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```
> Esto asegura que kubectl utilice la configuración de K3s.

Desplegar una aplicación de prueba (opcional):

Puedes desplegar una aplicación de prueba para verificar que todo funcione correctamente. Por ejemplo, puedes usar el siguiente manifiesto YAML para crear un pod de Nginx:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
```
## Guarda este manifiesto en un archivo llamado nginx-deployment.yaml y despliégalo con:

```bash
kubectl apply -f nginx-deployment.yaml
```
## Verifica que los pods estén en funcionamiento:

```bash
kubectl get pods

NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          1s
```


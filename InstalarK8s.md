# Instalar Docker


1. Actualizar el sistema

```bash
sudo apt-get update
```

2. Instalar dependencias

```bash
sudo apt install docker.io
```

3. Usar Docker como usuario no root

```bash
sudo usermod -aG docker $USER
```

4. Verificar el estado de docker

```bash
sudo systemctl status docker

🟢 docker.service - Docker Application Container Engine
     Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
     Active: active (running) since Fri 2024-01-19 14:47:53 UTC; 6h ago
TriggeredBy: 🟢 docker.socket
       Docs: https://docs.docker.com
   Main PID: 1194 (dockerd)
      Tasks: 9
     Memory: 25.4M
        CPU: 4.418s
     CGroup: /system.slice/docker.service
             └─1194 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
```

# Desactivar el swap

> Kubernetes no funciona correctamente con el swap activado

```bash
sudo swapoff -a
```

# setear SELinux en permissive mode

```bash
set SELinux in permissive mode
```

# Instalar kubeadm, kubelet y kubectl

> Descarga la clave pública para los repositorios de paquetes de Kubernetes. La misma clave de firma se utiliza para todos los repositorios, por lo que puedes ignorar la versión en la URL.

```bash
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
```

> **Note**: En releases mayores a Debian 12 y Ubuntu 22.04, la carpeta /etc/apt/keyrings no viene por defecto por lo que deberíamos crearla.

### Crear la carpeta /etc/apt/keyrings
```bash
sudo mkdir -p -m 755 /etc/apt/keyrings
```

## Agregamos el repositorio correcto de Kubernetes

```bash
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
```

## Actualizamos el sistema nuevamente

```bash
sudo apt-get update
```

## Instalamos kubelet kubeadm y kubectl

```bash
sudo apt-get install -y kubelet kubeadm kubectl
```

## Marcar los paquetes como hold

> Marcar un paquete como retenido impide que el sistema lo actualice automáticamente cuando se ejecuta el comando sudo apt-get upgrade o sudo apt-get dist-upgrade.

```bash	
sudo apt-mark hold kubelet kubeadm kubectl
```

## Inicializar el cluster

> Para inicializar el cluster, debemos ejecutar el siguiente comando:

```bash
kubeadm init --pod-network-cidr=192.168.0.0/16
```

## Cargamos la configuración

```bash
mkdir -p $HOME/.kube # Si no existe la carpeta la creamos
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config # Copiamos la configuración
sudo chown $(id -u):$(id -g) $HOME/.kube/config # Le damos permisos
```

## Ejecutamos el control plane

```bash
kubeadm init phase bootstrap-token

# obtenemos nodos con el siguiente comando
kubectl get nodes
```

## Instalar un pod network

> Para instalar un pod network, debemos ejecutar el siguiente comando:

```bash
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/tigera-operator.yaml
```

### Instalar el plugin de calico
    
```bash
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/custom-resources.yaml

installation.operator.tigera.io/default created
apiserver.operator.tigera.io/default created
``` 


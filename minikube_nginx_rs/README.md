# Minikube Nginx Tutorial

## Prerequisite
- [Minikube](https://github.com/kubernetes/minikube/releases) 
- [Kubernetes command-line tool](http://kubernetes.io/docs/user-guide/prereqs/)

## Ready to go

Start minikube (specify memory)
```bash
minikube start --memory 8192
```

Check that Kubernetes is up and running
```bash
kubectl cluster-info
Kubernetes master is running at https://<IP addr>:8443
```
### Create 3 nginx replication load balanced.

```bash
kubectl apply -f nginx.yaml
```
Check the replicas just wait a few seconds 

```bash
kubectl get pods
```

Check the internal IPs 
```bash
kubectl get services
```

Find the external IP

```bash
minikube service nginx-service --url 
```
![ngnix](/nginx.png)

#### Entering in a container

Execute the following command with the name of your first pod.
```bash
kubectl exec -ti nginx -- /bin/bash
```

Change the Nginx Page into the container and refresh
```bash
cd /usr/share/nginx/html/
rm index.html && echo "<html><body><h1>Hello Gabi</h1></body></html>" > index.html
exit
```
#### Delete deployment

```bash
kubectl delete -n default service nginx-service
kubectl delete -n default deployment nginx
```

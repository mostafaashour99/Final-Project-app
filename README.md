# GCP-Project

Deploy a python web application on GKE. if you need to know more about app you can go and read this readme file https://github.com/atefhares/DevOps-Challenge-Demo-Code in short its python app depend on redis

### 1. we need to build our image using docker and push it to GCR

#### Build image and upload to GCR
```
docker build -t <img-name> .
docker tag <img-name> gcr.io/<project-id>/<img-name>
docker push gcr.io/<project-id>/<img-name>
```

### 2. now we need to build infrastructure by 
```
cd terraform/
terraform init
terraform apply --var-files prod.tfvars
```

### 3.connect to private GKE cluster through bastion vm
```
gcloud compute ssh management-instance --tunnel-through-iap
gcloud container clusters get-credentials private-cluster --zone us-central1-a
```

### 4.deploy redis deploy and service u can find it on /k8s/redis/
```
kubectl apply -f redis-service.yaml
kubectl apply -f redis-deploy.yaml
```

### 5.now we need to get a sredis HOST_IP from redis service 
```
kubectl get service -o wide
```

### 6.copy ip and put it on helm values file k8s/app/pythonapp/ variable name ==> REDIS_HOST

```
vim values.yaml
```
### or use this way to set REDIS_HOST
```
 env:
     - name: REDIS_HOST
       value: redis.default.svc.cluster.local
       
```
### 7.Deploy app to GKE cluster and expose deploymnet through load balancer
```
helm install <appname> .
```

### 8.now u can access your app by using loadbalancer ip
```
kubectl get service -o wide
```
![Screenshot from 2022-10-30 23-12-35](https://user-images.githubusercontent.com/52250018/198902038-0fdb4f3a-a2c8-460a-8da7-f847ef8532d5.png)

#!/bin/bash

######################################################################
######################################################################
# 
# Pushed Kubernetes client stuff, other was too busy
# 
# https://minikube.sigs.k8s.io/docs/tutorials/multi_node/
# 
# 
######################################################################
######################################################################


######################################
######################################
#
# 1). Run a Pod
#
######################################
######################################


# Deploy simpleServerA pod
kubectl apply -f cluster\simpleServerA-Pod.yaml
kubectl get pod simple-server-a -o wide
kubectl logs simple-server-a
kubectl describe pod simple-server-a
kubectl delete pod simple-server-a


'''

--> Get
NAME              READY   STATUS    RESTARTS      AGE   IP          NODE             NOMINATED NODE   READINESS GATES
simple-server-a   1/1     Running   1 (42m ago)   70m   10.1.0.52   docker-desktop   <none>           <none>

--> Logs
2023-07-13 22:40:36.285 INFO: ServerA detected, exposing Hashing Endpoints
2023-07-13 22:40:36.285 INFO: Starting server
2023-07-13 22:40:36.290 INFO: Server configured on Port '8000', host '0.0.0.0'

--> Describe
Name:         simple-server-a
Namespace:    default
Status:       Running
IP:           10.1.0.52
Containers:
  simple-server-a:
    Container ID:  docker://59a1a8f300f460bddf8aafee226e2151f4dc9069faa05855a75db5fcffe2c4f9
    Image:         bkenna/simple-server-app
    Image ID:      docker-pullable://bkenna/simple-server-app@sha256:53b3e1b4fd09d95326b03c481e4098d7ca7f9a0505ff67aeaf08c361d6d5851c
    Port:          8000/TCP
    Host Port:     8000/TCP
    Command:
      /usr/local/bin/node
    Args:
      index.js
      --server
      Server-A
      --port
      8000
    State:          Running
      Started:      Thu, 13 Jul 2023 23:40:35 +0100
'''


######################################
######################################
#
# 2). Deploy a Service
#
######################################
######################################

# Run simpleServerA deployment
kubectl apply -f cluster\simpleServerA-deployment.yaml
kubectl get pods simple-server-a-8667d8d9cb-kn7gq -o wide
kubectl logs simple-server-a--8667d8d9cb-kn7gq

'''
deployment.apps/simple-server-a created

--> Noteable fields sides first few
{
    "spec": {
        "volumes": [],
        "dnsPolicy": "ClusterFirst",
        "schedulerName": "default-scheduler",
        "securityContext": {},
        "serviceAccount": "default",
        "serviceAccountName": "default",
        "nodeName": "dockerDesktop"
    }
    "phase": "Running"
}


--> Logs

2023-07-13 23:10:56.813 INFO: ServerA detected, exposing Hashing Endpoints
2023-07-13 23:10:56.813 INFO: Starting server
2023-07-13 23:10:56.818 INFO: Server configured on Port '8000', host '0.0.0.0'

'''


# Inspect deployment
kubectl get deployment -o wide
kubectl get replicaset -o wide


'''

--> Deployment
NAME              READY   UP-TO-DATE   AVAILABLE   AGE    CONTAINERS        IMAGES                     SELECTOR
simple-server-a   1/1     1            1           9m6s   simple-server-a   bkenna/simple-server-app   app.kubernetes.io/component=yolo,app.kubernetes.io/name=simple-server-a


--> Replicaset

NAME                         DESIRED   CURRENT   READY   AGE     CONTAINERS        IMAGES                     SELECTOR
simple-server-a-8667d8d9cb   1         1         1       9m32s   simple-server-a   bkenna/simple-server-app   app.kubernetes.io/component=yolo,app.kubernetes.io/name=simple-server-a,pod-template-hash=8667d8d9cb
'''


# Run the simpleServerA service
kubectl apply -f cluster\simpleServerA-service.yaml
kubectl expose deployment simple-server-a --type=NodePort --name=simple-server-a
kubectl get service simple-server-a -o wide
kubectl describe services simple-server-a

'''
service/simple-server-a created

NAME              TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE     SELECTOR
simple-server-a   ClusterIP   10.98.132.115   <none>        8000/TCP   3m36s   app.kubernetes.io/component=yolo,app.kubernetes.io/name=simple-server-a

NAME              TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE   SELECTOR
simple-server-a   NodePort   10.104.69.229   <none>        8000:30375/TCP   39s   app.kubernetes.io/component=yolo,app.kubernetes.io/name=simple-server-a


Name:                     simple-server-a
Namespace:                default
Labels:                   app.kubernetes.io/component=yolo
                          app.kubernetes.io/name=simple-server-a
Annotations:              <none>
Selector:                 app.kubernetes.io/component=yolo,app.kubernetes.io/name=simple-server-a
Type:                     NodePort
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.104.69.229
IPs:                      10.104.69.229
LoadBalancer Ingress:     localhost
Port:                     <unset>  8000/TCP
TargetPort:               8000/TCP
NodePort:                 <unset>  30375/TCP
Endpoints:                10.1.0.55:8000
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
'''

# Post a hashing with salt request to exposed endpoint
curl http://localhost:30375/hashing/hashMessageWithSalt \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"message": "xdfrtyu7i8opl;lkj"}' \
 | jq .

kubectl logs service/simple-server-a

'''

--> Request results

{
  "Message": "xdfrtyu7i8opl;lkj",
  "Hash": "98e9a19c0cf1b3ce17543240caae22f553441cb2af94ef241c0ff357d647f522",
  "Salt": "a79a9c5d-522a-4d1a-8eda-97bed90a3bdb"
}


--> Server logs

2023-07-13 23:10:56.807 INFO:
Displaying Requested Server = 'Server-A'
Displaying Requested Port = '8000'

2023-07-13 23:10:56.810 INFO: Parser {
  argData: Map(3) {
    'Description' => 'Simple web server, for kubernetes tinkering with a Server-A & Server-B.',
    'Actions' => Map(0) {},
    'Global Arguments' => Map(3) { 'State' => 1, 'Server' => [Map], 'Port' => [Map] }
  }
}
2023-07-13 23:10:56.813 INFO: ServerA detected, exposing Hashing Endpoints
2023-07-13 23:10:56.813 INFO: Starting server
2023-07-13 23:10:56.818 INFO: Server configured on Port '8000', host '0.0.0.0'
2023-07-13 23:58:51.709 INFO: A new test request has come in
2023-07-14 00:00:29.771 INFO: A new hashing request has come in
2023-07-14 00:00:29.772 INFO: { message: 'xdfrtyu7i8opl;lkj' }
2023-07-14 00:00:29.780 INFO: {
  Message: 'xdfrtyu7i8opl;lkj',
  Hash: '98e9a19c0cf1b3ce17543240caae22f553441cb2af94ef241c0ff357d647f522',
  Salt: 'a79a9c5d-522a-4d1a-8eda-97bed90a3bdb'
}

'''


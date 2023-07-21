#!/bin/bash

# Create namespace for spark
kubectl apply -f kubernetes-deployment/simpleSpark/spark-Namespace.yml
kubectl apply -f kubernetes-deployment/simpleSpark/spark-AccountRole.yml

'''
serviceaccount/spark created
role.rbac.authorization.k8s.io/pod-reader created
'''

# 
kubectl create clusterrolebinding spark-role \
    --clusterrole=edit \
    --serviceaccount=spark-space:spark \
    --namespace=spark-space

'''
clusterrolebinding.rbac.authorization.k8s.io/spark-role created
'''

# Inspect permissions
kubectl auth can-i --list --namespace=spark-space
kubectl auth can-i create pod --namespace=spark-space


############################
#
# PySpark Jobs: apache/spark-py
#
############################

# Download spark
wget https://dlcdn.apache.org/spark/spark-3.4.1/spark-3.4.1-bin-hadoop3.tgz
tar -xf spark-3.4.1-bin-hadoop3.tgz

# Build docker images
spark-3.4.1-bin-hadoop3/bin/docker-image-tool.sh -r bkenna -t latest build
spark-3.4.1-bin-hadoop3/bin/docker-image-tool.sh -r bkenna -t latest push


# Run test pod
kubectl run spark-test-pod \
    --rm=true \
    --image=bkenna/spark \
    --namespace=spark-space \
    --serviceaccount=spark \
    -it \
    --command -- /bin/bash

kubectl apply -f kubernetes-deployment/simpleSpark/spark-driver.Pod.yml


# Proxy request to cluster
# Allows  --master k8s://http://127.0.0.1:8001
# kubectl proxy --api-prefix=/spark-space <= Dont use
kubectl proxy
curl http://127.0.0.1:8001/api/v1/namespaces/spark-space/pods
'''
{
  "kind": "PodList",
  "apiVersion": "v1",
  "metadata": {
    "resourceVersion": "24647"
  },
  "items": []
'''

# Start spark shell
spark-3.4.1-bin-hadoop3/bin/spark-submit \
    --master k8s://http://127.0.0.1:8001 \
    --deploy-mode cluster \
    --name sparkPi_Test \
    --class org.apache.spark.examples.SparkPi \
    --conf spark.executor.instances=3 \
    --conf spark.kubernetes.container.image=bkenna/spark \
    --conf spark.kubernetes.namespace=spark-space \
    --conf spark.kubernetes.container.image.pullPolicy=IfNotPresent \
    --conf spark.kubernetes.driver.podTemplateFile=./kubernetes-deployment/simpleSpark/spark-driver.Pod.yml \
    --conf spark.kubernetes.executor.podTemplateFile=./kubernetes-deployment/simpleSpark/spark-executor.Pod.yml\
    --conf spark.kubernetes.executor.podTemplateContainerName=sparkPi_Test-executor \
    --conf spark.kubernetes.authenticate.serviceAccountName=spark \
    --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
    local:///opt/spark/examples/jars/spark-examples_2.12-3.4.1.jar

'''

23/07/21 15:38:06 INFO LoggingPodStatusWatcherImpl: Application status for spark-e943006d11124491b55c28224c81f4a5 (phase: Running)
23/07/21 15:38:07 INFO LoggingPodStatusWatcherImpl: Application status for spark-e943006d11124491b55c28224c81f4a5 (phase: Running)

'''


# Fetch pods metadata
kubectl get pods --namespace=spark-space -o json | jq . | less
curl http://127.0.0.1:8001/api/v1/namespaces/spark-space/pods | jq . | less


'''
NAME                                   READY   STATUS             RESTARTS         AGE
spark-pi-18ab538978ff9c2d-exec-1       1/1     Running            0                31s
spark-pi-18ab538978ff9c2d-exec-2       0/1     Pending            0                31s
spark-pi-18ab538978ff9c2d-exec-3       0/1     Pending            0                31s
sparkpi-test-6995888978ff7948-driver   1/1     Running            0                37s
'''

# Fetch driver logs
# Executor logs do not hang around too long?
kubectl logs --namespace=spark-space sparkpi-test-8783898978d0de9f-driver | less

kubectl logs --namespace=spark-space spark-pi-b309aa897901d383-exec-1

'''

--> Driver is not taking the "spark" user name in the spark-space namespace

Caused by: io.fabric8.kubernetes.client.KubernetesClientException: Failure executing: GET at: https://kubernetes.default.svc/api/v1/namespaces/spark-space/pods/sparkpi-test-63205b8978e78f8f-driver. 
Message: Forbidden!Configured service account doesnt have access. 
Service account may have been revoked. pods "sparkpi-test-63205b8978e78f8f-driver" is forbidden:
User "system:serviceaccount:spark-space:default" cannot get resource "pods" in API group "" in the namespace "spark-space".


--> Successful creation of spark context on cluster & executors, reducing of executor results, and closing of SC

23/07/21 14:50:21 INFO BlockManagerMaster: Registered BlockManager BlockManagerId(driver, sparkpi-test-3cd8798978edfe91-driver-svc.spark-space.svc, 7079, None)
23/07/21 14:50:21 INFO BlockManager: Initialized BlockManager: BlockManagerId(driver, sparkpi-test-3cd8798978edfe91-driver-svc.spark-space.svc, 7079, None)
23/07/21 14:50:29 INFO KubernetesClusterSchedulerBackend$KubernetesDriverEndpoint: Registered executor NettyRpcEndpointRef(spark-client://Executor) (10.1.0.161:44728) with ID 1,  ResourceProfileId 0

23/07/21 14:50:29 INFO BlockManagerMasterEndpoint: Registering block manager 10.1.0.161:43307 with 413.9 MiB RAM, BlockManagerId(1, 10.1.0.161, 43307, None)
23/07/21 14:50:50 INFO KubernetesClusterSchedulerBackend: SchedulerBackend is ready for scheduling beginning after waiting maxRegisteredResourcesWaitingTime: 30000000000(ns)
23/07/21 14:50:51 INFO SparkContext: Starting job: reduce at SparkPi.scala:38
23/07/21 14:50:51 INFO DAGScheduler: Got job 0 (reduce at SparkPi.scala:38) with 2 output partitions
23/07/21 14:50:51 INFO DAGScheduler: Final stage: ResultStage 0 (reduce at SparkPi.scala:38)
23/07/21 14:50:51 INFO DAGScheduler: Parents of final stage: List()
23/07/21 14:50:52 INFO TaskSchedulerImpl: Killing all running tasks in stage 0: Stage finished
23/07/21 14:50:52 INFO DAGScheduler: Job 0 finished: reduce at SparkPi.scala:38, took 1.119517 s
Pi is roughly 3.1335556677783387
23/07/21 14:50:52 INFO SparkContext: SparkContext is stopping with exitCode 0.
23/07/21 14:50:52 INFO SparkUI: Stopped Spark web UI at http://sparkpi-test-3cd8798978edfe91-driver-svc.spark-space.svc:4040


--> Executor logs snippet

23/07/21 15:11:55 INFO CoarseGrainedExecutorBackend: Successfully registered with driver
23/07/21 15:11:55 INFO Executor: Starting executor ID 1 on host 10.1.0.165
23/07/21 15:11:55 INFO Utils: Successfully started service 'org.apache.spark.network.netty.NettyBlockTransferService' on port 45235.
23/07/21 15:11:55 INFO NettyBlockTransferService: Server created on 10.1.0.165:45235
'''

# Kill
spark-submit --kill spark:sparkPi_Test* --master k8s://http://127.0.0.1:8001
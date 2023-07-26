#!/bin/bash

############################################################
#
# HDFS on K8
#
# While I feel it sounds better than it is for prod
#   --> More of a curiosity project, persistent volumes
#
# Reference:
# - https://hasura.io/blog/getting-started-with-hdfs-on-kubernetes-a75325d4178c/#3d98
# - https://github.com/k8s-platform-hub/hub-hdfs/tree/master
# 
############################################################

###########################
#
# 1). Directory for PVs
# 
###########################

# Create
mkdir /home/bren/data

# Configure PVs
kubectl apply -f kubernetes-deployment/hdfsExample/persistentVolumes.yml
kubectl delete \
    persistentvolume/namenode-pv \
    persistentvolumeclaim/hdfs-name \
    persistentvolume/datanode-vol1-pv \
    persistentvolume/datanode-vol2-pv \
    persistentvolume/datanode-vol3-pv

'''
persistentvolume/namenode-pv created
persistentvolumeclaim/hdfs-name created
persistentvolume/datanode-vol1-pv created
persistentvolume/datanode-vol2-pv created
persistentvolume/datanode-vol3-pv created
'''


###########################
# 
# 2). Name Node
# 
###########################

# Name node service
kubectl apply -f kubernetes-deployment/hdfsExample/namenode/namenode-Deployment.yml
kubectl apply -f kubernetes-deployment/hdfsExample/namenode/namenode-Service.yml

'''
deployment.apps/namenode created
service/namenode created
'''

###########################
# 
# 3). Data Node
# 
###########################


# Data node service
kubectl apply -f kubernetes-deployment/hdfsExample/datanode/datanode-Deployment.yml
kubectl apply -f kubernetes-deployment/hdfsExample/datanode/datanode-Service.yml

'''
statefulset.apps/datanode created
'''


###########################
# 
# 4). Scope Out
# 
###########################

# Run shell in primary node pod
kubectl exec -it namenode-5d5bb45898-xsbzz -- /bin/sh


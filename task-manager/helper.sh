#!/bin/bash

###########################################
###########################################
# 
# Fastify - Task Manager Server
# 
###########################################
###########################################


# Run server
node index.js

'''
{"level":30,"time":1689703057308,"pid":11880,"hostname":"LAPTOP-SL02RC0C","msg":"Server listening at http://127.0.0.1:3000"}
{"level":30,"time":1689703057310,"pid":11880,"hostname":"LAPTOP-SL02RC0C","msg":"Server listening at http://[::1]:3000"}
{"level":30,"time":1689703069229,"pid":11880,"hostname":"LAPTOP-SL02RC0C","reqId":"req-1","req":{"method":"GET","url":"/","hostname":"localhost:3000","remoteAddres
s":"::1","remotePort":60247},"msg":"incoming request"}
{"level":30,"time":1689703069243,"pid":11880,"hostname":"LAPTOP-SL02RC0C","reqId":"req-1","res":{"statusCode":200},"responseTime":13.215400040149689,"msg":"request
 completed"}
'''


# Run tests
cd DevOps-CCT/task-manager
npm test

''' 

> task-manager@1.0.0 test
> tap --reporter=list --no-coverage


    {"level":30,"time":1689708581373,"pid":20476,"hostname":"LAPTOP-SL02RC0C","reqId":"req-1","req":{"method":"GET","url":"/","hostname":"localhost:80","remoteAddress":"127.0.0.1"},"msg":"incoming request"}
  . server.test.js requests the "/" route returns a status code of 200
    {"level":30,"time":1689708581393,"pid":20476,"hostname":"LAPTOP-SL02RC0C","reqId":"req-1","req":{"method":"GET","url":"/tasks","hostname":"localhost:80","remoteAddress":"127.0.0.1"},"msg":"incoming request"}
  . server.test.js test getting an empty task array returns a status code of 200
  . server.test.js test getting an empty task array should be equal
    {"level":30,"time":1689708581402,"pid":20476,"hostname":"LAPTOP-SL02RC0C","reqId":"req-1","req":{"method":"POST","url":"/task","hostname":"localhost:80","remoteAddress":"127.0.0.1"},"msg":"incoming request"}
  . server.test.js test posting a task returns a status code of 200
  . server.test.js test posting a task should not be equal
    {"level":30,"time":1689708581412,"pid":20476,"hostname":"LAPTOP-SL02RC0C","reqId":"req-1","req":{"method":"GET","url":"/tasks","hostname":"localhost:80","remoteAddress":"127.0.0.1"},"msg":"incoming request"}
  . server.test.js test fetching an empty array returns an empty array
    {"level":30,"time":1689708581378,"pid":20476,"hostname":"LAPTOP-SL02RC0C","reqId":"req-1","res":{"statusCode":200},"responseTime":3.830399990081787,"msg":"request completed"}
    {"level":30,"time":1689708581393,"pid":20476,"hostname":"LAPTOP-SL02RC0C","reqId":"req-1","res":{"statusCode":200},"responseTime":0.6420000195503235,"msg":"request completed"}
    {"level":30,"time":1689708581405,"pid":20476,"hostname":"LAPTOP-SL02RC0C","reqId":"req-1","res":{"statusCode":200},"responseTime":3.4800999760627747,"msg":"request completed"}
    {"level":30,"time":1689708581413,"pid":20476,"hostname":"LAPTOP-SL02RC0C","reqId":"req-1","res":{"statusCode":200},"responseTime":0.49010002613067627,"msg":"request completed"}

  6 passing (630.514ms)

  '''


# Build image
docker build -f dockerfiles/task-manager/nodeApline.Dockerfile -t task-manager-app ./task-manager/
docker tag task-manager-app bkenna/task-manager-app:latest
docker push task-manager-app

'''


'''
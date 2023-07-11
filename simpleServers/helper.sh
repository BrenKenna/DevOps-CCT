#!/bin/bash

######################################################################
######################################################################
# 
# Contents:
#   1). Basic project setup - Express
#   2). Building Docker image & verifying working directory
#   3). Running Express server, cURL Testing & Log Fetching
# 
######################################################################
######################################################################


##############################################
##############################################
# 
# 1). Setup
# 
##############################################
##############################################

# Initialize project
npm init

# Install dependancies
npm install path express log4js

# Check 
node index.js


##############################################
##############################################
# 
# 2). Build Container
# 
###############################################
###############################################


# Build container
docker build -f dockerfiles/simpleServers/nodeAlpine.Dockerfile -t simpler-server-app simpleServers/


# Test run container
docker run simpler-server-app ls -lh


"""
total 76K
-rwxrwxrwx    1 root     root        3.3K Jul 11 18:33 helper.sh
-rwxrwxrwx    1 root     root        2.5K Jul 11 18:30 index.js
drwxrwxrwx   75 root     root        4.0K Jul 11 18:26 node_modules
-rwxrwxrwx    1 root     root       51.8K Jul 11 12:54 package-lock.json
-rwxrwxrwx    1 root     root         441 Jul 11 12:54 package.json
-rwxrwxrwx    1 root     root        1.9K Jul 11 17:37 server.js
drwxrwxrwx    5 root     root        4.0K Jul 11 18:26 supporting
"""



##############################################
##############################################
# 
# 3). Run Web Server 
# 
###############################################
###############################################


# Run app listening on port 8000
docker run -d -p 8000:8000 simpler-server-app node index.js --server 'Server-A' --port 8000
docker logs "6527cbd17208"

'''
2023-07-11 19:02:04 INFO:
Displaying Requested Server = 'Server-A'
Displaying Requested Port = '8000'

2023-07-11 19:02:04 INFO: Parser {
  argData: Map(3) {
    'Description' => 'Simple web server, for kubernetes tinkering with a Server-A & Server-B.',
    'Actions' => Map(0) {},
    'Global Arguments' => Map(3) { 'State' => 1, 'Server' => [Map], 'Port' => [Map] }
  }
}

2023-07-11 19:02:04 INFO: Starting server

2023-07-11 19:02:04 INFO: Server configured on Port '8000', host '0.0.0.0'
'''


# Fetch welcom message
curl http://localhost:8000/ | jq

'''
{
  "Hello": "World!!!"
}
'''

# Fetch hash of message
curl http://localhost:8000/hashing \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"message": "xdfrtyu7i8opl;lkj"}' \
 | jq

'''
{
  "Hash": "fa61e928fb427485fd3161df3bfb951ba81fd96c0e6a57679e13b9bee08ff53a",
  "Salt": "dea40789-8000-45af-89c3-d5d22eafa345"
}
'''


# Encrypt a message
curl http://localhost:8000/encrypting \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"message": "xdfrtyu7i8opl;lkj"}' \
 | jq

'''
{
  "Message": "xdfrtyu7i8opl;lkj",
  "EncryptedMessage": "bfa5087dbcb43529975cabaf464c70a5fdc588905c43cbe3afd24f9afa2fbbb7"
}
'''


# Decrypt a message
curl http://localhost:8000/decrypting \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"message": "bfa5087dbcb43529975cabaf464c70a5fdc588905c43cbe3afd24f9afa2fbbb7"}' \
 | jq

'''
{
  "Message": "bfa5087dbcb43529975cabaf464c70a5fdc588905c43cbe3afd24f9afa2fbbb7",
  "DecryptedMesssage": "xdfrtyu7i8opl;lkj"
}
'''


# Display server logs following tests
docker logs 6527cbd17208

'''
2023-07-11 19:02:33 INFO: A new test request has come in

2023-07-11 19:02:49 INFO: A new hashing request has come in

2023-07-11 19:02:49 INFO: { message: 'xdfrtyu7i8opl;lkj' }

2023-07-11 19:02:49 INFO: {
  Message: undefined,
  Hash: 'fa61e928fb427485fd3161df3bfb951ba81fd96c0e6a57679e13b9bee08ff53a',
  Salt: 'dea40789-8000-45af-89c3-d5d22eafa345'
}

2023-07-11 19:03:05 INFO: A new encryption request has come in

2023-07-11 19:03:05 INFO: { message: 'xdfrtyu7i8opl;lkj' }

2023-07-11 19:03:05 INFO: {
  Message: 'xdfrtyu7i8opl;lkj',
  EncryptedMessage: 'bfa5087dbcb43529975cabaf464c70a5fdc588905c43cbe3afd24f9afa2fbbb7'
}

2023-07-11 19:03:29 INFO: A new decryption request has come in

2023-07-11 19:03:29 INFO: {
  message: 'bfa5087dbcb43529975cabaf464c70a5fdc588905c43cbe3afd24f9afa2fbbb7'
}

2023-07-11 19:03:29 INFO: {
  Message: 'bfa5087dbcb43529975cabaf464c70a5fdc588905c43cbe3afd24f9afa2fbbb7',
  DecryptedMesssage: 'xdfrtyu7i8opl;lkj'
}
'''
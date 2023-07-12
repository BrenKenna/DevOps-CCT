#!/bin/bash

#############################################
# 
# Request Encrypion From Provided Endpoint
# 
#############################################

# Declare required vars
toHash=$(echo $RANDOM | md5sum -)

# Send request
date
curl -s http://localhost:8000/encrypting/encrypt \
  -X POST \
  -H "Content-Type: application/json" \
  -d "{\"message\": \"$toHash\"}" \
 | jq .
date
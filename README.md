# CCT DevOps
Code from classes from DevOps Diploma course at CCT.


## SimpleServers
Simple Node.js server with endpoints for hashing, de/encrypting messages sent by the client (Express.js), using '***log4js***' for logging.
The GET/POST requests were tested using cURL and shown in the "*simpleServers/helper.sh*".

Rational is that a set of docker containers would be dedicated for hashing a client-side message, and another set of containers responsible for de/encrypting client-side messages.


# CCT DevOps

Code from classes from DevOps Diploma course at CCT.

  
  

## SimpleServers

Simple Node.js server with endpoints for hashing, de/encrypting messages sent by the client (Express.js), using '***log4js***' for logging.

The GET/POST requests were tested using cURL and shown in the "*simpleServers/helper.sh*".

  

Rational is that a set of docker containers would be dedicated for hashing a client-side message, and another set of containers responsible for de/encrypting client-side messages.


## Task Manager

While it uses fastify, more about what goes into having images ready for integration testing. As ideally, the related container image will only be built, on the condition that the latest version, satisifies its unit testing. Comparing with the above, just serverA and serverB both pass, does not necessarily mean the serverC that talks to both can still use them. So why not test it, before doing so.

Atm, its about updating live deployment. Can add elements from class work, ie github actions, regarding fullfilling this.

Note on fastify, do like the request layout. Otherwise similar coding to express, but acknowledge performance gains.
  

## Notes from Testing & Development

- Current webserver would be very useful in tinkering with various configurations in Kubernetes. Such as, Pod for ServerA etc, as well providing arguments for containers.

  
  

- While I am not too fuzzed about image size given its <200MB, do prefer the current layout in terms of Controller, Routes etc. Where separating such concerns makes a project more maintainable.

  
  

- The test results from running an increasing number of parallel cURL requests on my local computer, were suprising. In that hashing & encryption were just as fast, but also the quick response times for up to 1k requests.

  
  

- I would be curious how true this is, and would like verify this with requests coming from separate computers (under a framework like '*[BrenKenna-PyAnamo](https://github.com/BrenKenna/pyanamo)*'). The webserver could be in the same private netwok as the ECS cluster to keep things simple, however could break free tier limit quite quickly :c.

  
  

- I would be more curious, about change in response time a REST-API has to convert a Model class into an instance of class that Database knows (notes from '*[BrenKenna-JavaBase](https://github.com/BrenKenna/JavaBase)*').
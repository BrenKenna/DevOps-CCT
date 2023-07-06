#!/bin/bash

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
npm install http path express fs

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
cd simpleServers
docker build -f ../dockerfiles/justNode/Dockerfile -t simpler-server-app .



# Test run container
docker run simpler-server-app node index.js --server 'Server-A'
docker run simpler-server-app node index.js --server 'Server-B'


"""
Displaying Requested Server = 'Server-A'
Displaying parser:
Parser {
  argData: Map(3) {
    'Description' => 'Simple web server, for kubernetes tinkering with a Server-A & Server-B.',
    'Actions' => Map(0) {},
    'Global Arguments' => Map(2) {
      'State' => 1,
      'Server' => Map(3) {
        'State' => 1,
        'Description' => 'Which server to run',
        'Keys' => Map(2) {
          'search' => [ '-S', '--server' ],
          'value' => 'Server-A'
        }
      }
    }
  }
}


Displaying Requested Server = 'Server-B'
...

"""
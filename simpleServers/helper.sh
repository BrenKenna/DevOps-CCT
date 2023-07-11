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
cd simpleServers
docker build -f ../dockerfiles/simpleServers/nodeAlpine.Dockerfile -t simpler-server-app .


# Test run container
docker run simpler-server-app node index.js --server 'Server-A'
docker run simpler-server-app node index.js --server 'Server-B'


"""
2023-07-11 14:07:12 INFO:
Displaying Requested Server = 'Server-A'

2023-07-11 14:07:12 INFO: Parser {
  argData: Map(3) {
    'Description' => 'Simple web server, for kubernetes tinkering with a Server-A & Server-B.',
    'Actions' => Map(0) {},
    'Global Arguments' => Map(2) { 'State' => 1, 'Server' => [Map] }
  }
}

2023-07-11 14:07:12 INFO: Initializing the message handler

2023-07-11 14:07:12 INFO: MessageHandler {
  messageHasher: MessageHasher {
    hasher: Hash {
      _options: undefined,
      [Symbol(kHandle)]: Hash {},
      [Symbol(kState)]: [Object]
    }
  },
  messageCipher: MessageEncryptor {
    msgKey: <Buffer >,
    msgIV: <Buffer >,
    cipher: Cipheriv {
      _decoder: null,
      _options: undefined,
      [Symbol(kHandle)]: CipherBase {}
    },
    deCipher: Decipheriv {
      _decoder: null,
      _options: undefined,
      [Symbol(kHandle)]: CipherBase {}
    }
  }
}

2023-07-11 14:07:12 INFO: Generated Salt:
bd3680da-6847-4ca7-905f-7cc6a30a6fee

2023-07-11 14:07:12 INFO: Generated hash of 'hello':
2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824

2023-07-11 14:07:12 INFO: {
  Message: 'hello',
  Hash: '94f58da1e61edfaaa1a734094a691bece31c685589b7e795b0791d236e8b3692',
  Salt: '75501924-c573-4e27-a84d-b41a83f27ea5'
}

2023-07-11 14:07:12 INFO: Encrypting message

2023-07-11 14:07:12 INFO: {
  Message: 'hello',
  EncryptedMessage: '23f3365ab2723c3db6b6e1a0ee3f2dba'
}

2023-07-11 14:07:12 INFO: {
  Message: 'hello',
  EncryptedMessage: '23f3365ab2723c3db6b6e1a0ee3f2dba'
}

2023-07-11 14:07:12 INFO: Decrypting message

2023-07-11 14:07:12 INFO: {
  Message: '23f3365ab2723c3db6b6e1a0ee3f2dba',
  DecryptedMesssage: 'hello'
}

2023-07-11 14:07:12 INFO: {
  Message: '23f3365ab2723c3db6b6e1a0ee3f2dba',
  DecryptedMesssage: 'hello'
}

"""

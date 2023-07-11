/**
 * Simple web server-B
 */

// Import required modules
const 
    http = require('http'),
    crypto = require('crypto'),
    path = require('path'),
    express = require('express'),
    fs = require('fs')
;

// Initialize cipher
let msg, msgKey, msgKeyB, msgEnc;
msg = 'hello';
msgKey = crypto.randomUUID();
msgKeyB = Buffer.from(crypto.randomUUID(), "utf-8");
let cipherB = crypto.createCipheriv('aes-128-cbc', msgKey, msgKeyB);


// Encrypt
hasher.update('hello');
msgHash = hasher.digest('hex');
console.log(`
Original Message:\t${msg}
Hashed Message:\t\t${msgHash}
`);
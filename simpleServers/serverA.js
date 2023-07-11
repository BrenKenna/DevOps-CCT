/**
 * Simple web server-A
 */

// Import required modules
const 
    http = require('http'),
    crypto = require('crypto'),
    path = require('path'),
    express = require('express'),
    fs = require('fs')
;


// Initialize the hasher
let msg, msgHash;
const hasher = crypto.createHash('sha256');


// Hash msg
msg = 'hello';
hasher.update('hello');
msgHash = hasher.digest('hex');
console.log(`
Original Message:\t${msg}
Hashed Message:\t\t${msgHash}
`);
/**
 * Handle which server to run
 */

// Fetch required libs
const 
    Parser = require('./supporting/arg_parser/parser'),
    express = require('express'),
    bodyParser = require('body-parser'),
    MessageHandler = require('./supporting/messageHandler/MessageHandler'),
    appLogger = require('./supporting/logging/appLogger')
;


/**
 * Parse command line arguments for 
 */

// Configure cmd-line arg parser
const parser = new Parser();
parser.setDescription("Simple web server, for kubernetes tinkering with a Server-A & Server-B.");
parser.addArg("Server", "Which server to run", "-S,--server");
parser.addArg("Port", "Which port to listen on", "-P,--port")
parser.updateGlobalVariables();
const
    server = parser.getGlobalArgumentValue("Server");
    port = parser.getGlobalArgumentValue("Port")
;
appLogger.info(`
Displaying Requested Server = '${server}'
Displaying Requested Port = '${port}'`);
appLogger.info(parser);


/**
 * Use args for spinning up server
 */

// Configure http server & the message handler
const
    msgHandler = new MessageHandler(),
    app = express(),
    host = '0.0.0.0'
;
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
    extended: true
}));


// Testing
app.get("/", (req, resp) => {
    appLogger.info(`A new test request has come in`);
    let output = {
        "Hello": "World!!!"
    };
    resp.send(output);
});


// Hashing endpoint
app.post("/hashing", (req, resp) => {
    
    // Handle input message
    appLogger.info(`A new hashing request has come in`);
    appLogger.info(req.body);
    let output = msgHandler.hashMsgWithSalt(req.body.message);
    appLogger.info(output);

    // Write and send resonse
    resp.send(output);
});


// Encryption endpoint
app.post("/encrypting", (req, resp) => {
    
    // Handle input message
    appLogger.info(`A new encryption request has come in`);
    appLogger.info(req.body);
    let output = msgHandler.encryptMsg(req.body.message)
    appLogger.info(output);

    // Write and send resonse
    resp.send(output);
});


// Decryption endpoint
app.post("/decrypting", (req, resp) => {
    
    // Handle input message
    appLogger.info(`A new decryption request has come in`);
    appLogger.info(req.body);
    let output = msgHandler.decryptMsg(req.body.message);
    appLogger.info(output);

    // Write and send resonse
    resp.send(output);
});


// Start server
appLogger.info("Starting server");
app.listen(port, process.env.IP || '0.0.0.0', () => {
    appLogger.info(`Server configured on Port '${port}', host '${host}'`);
});
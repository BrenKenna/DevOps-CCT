/**
 * Handle which endpoints to expose for server
 *  - ServerA = Hashing
 *  - ServerB = Encryption
 * 
 */

// Fetch required libs
const
    express = require('express'),
    bodyParser = require('body-parser'),
    Parser = require('./supporting/arg_parser/parser'),
    appLogger = require('./supporting/logging/appLogger'),
    hashingRouter = require('./Routes/hashingRouter'),
    cipherRouter = require('./Routes/cipherRouter')
;


/**
 * 
 * Parse command line arguments for 
 * 
 */

// Configure cmd-line arg parser
const parser = new Parser();
parser.setDescription("Simple web server, for kubernetes tinkering with a Server-A & Server-B.");
parser.addArg("Server", "Which server to run", "-S,--server");
parser.addArg("Port", "Which port to listen on", "-P,--port");
parser.updateGlobalVariables();
const
    server = parser.getGlobalArgumentValue("Server"),
    port = parser.getGlobalArgumentValue("Port")
;
appLogger.info(`
Displaying Requested Server = '${server}'
Displaying Requested Port = '${port}'\n`);
appLogger.info(parser);


/**
 * 
 * Use args for spinning up server
 * 
 */

// Configure http server & the message handler
const
    app = express(),
    host = '0.0.0.0'
;
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
    extended: true
}));


/**
 * 
 * Configure endpoints
 * 
 */

// Testing
app.get("/", (req, resp) => {
    appLogger.info(`A new test request has come in`);
    let output = {
        "Hello": "World!!!"
    };
    resp.send(output);
});


// Expose hashing if ServerA
if ( server.toLowerCase() === "servera" || server.toLowerCase() === "server-a" ) {
    appLogger.info("ServerA detected, exposing Hashing Endpoints");
    app.use("/hashing", hashingRouter);
}

// Otherwise expose encryption if ServerB
else if ( server.toLowerCase() === "serverb" || server.toLowerCase() === "server-b" ) {
    appLogger.info("ServerB detected, exposing Encrypting Endpoints");
    app.use("/encrypting", cipherRouter);
}

// Otherwise expose both, and log warning
else {
    appLogger.warn("Unable to detect which server to run, exposing hashing & encrypted endpoints");
    app.use("/hashing", hashingRouter);
    app.use("/encrypting", cipherRouter);
}



/**
 * 
 * Start server
 * 
 */

// Start server
appLogger.info("Starting server");
app.listen(port, host, () => {
    appLogger.info(`Server configured on Port '${port}', host '${host}'`);
});
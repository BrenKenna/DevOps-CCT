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
    MessageHandler = require('./supporting/messageHandler/MessageHandler'),
    Parser = require('./supporting/arg_parser/parser'),
    appLogger = require('./supporting/logging/appLogger'),
    hashingRouter = require('./Routes/hashingRouter'),
    cipherRouter = require('./Routes/cipherRouter');
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
 * 
 * Use args for spinning up server
 * 
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


// Hashing endpoints: If serverA then use
app.use("/hashing", hashingRouter);


// Encryption endpoints: If serverB then use
app.use("/encrypting", cipherRouter);


/**
 * 
 * Start server
 * 
 */

// Start server
appLogger.info("Starting server");
app.listen(port, process.env.IP || '0.0.0.0', () => {
    appLogger.info(`Server configured on Port '${port}', host '${host}'`);
});
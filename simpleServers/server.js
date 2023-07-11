const
    http = require('http'),
    express = require('express'),
    bodyParser = require('body-parser'),
    path = require('path'),
    MessageHandler = require('./supporting/messageHandler/MessageHandler'),
    appLogger = require('./supporting/logging/appLogger')
;


// Configure http server
const
    msgHandler = new MessageHandler(),
    app = express(),
    port = 8000,
    host = '0.0.0.0'
;
// server = http.createServer(app);
app.use(express.json);
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
  extended: true
}));


// Testing
app.get("/", (req, res) => {
    appLogger.info(`A new test request has come in`);
    let output = {
        "Hello": "World!"
    };
    res.send(JSON.stringify(output));
    res.end();
});


// Hashing endpoint
app.post("/hashing", (req, res) => {
    
    // Handle input message
    appLogger.info(`A new hashing request has come in`);
    let output = msgHandler.hashMsg(req.body.Msg);
    appLogger.info(output);

    // Write and send resonse
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.send(JSON.stringify(output));
    res.end();
});


// Encryption endpoint
app.post("/encrypting", (req, res) => {
    
    // Handle input message
    appLogger.info(`A new encryption request has come in`);
    let output = msgHandler.encryptMsg(req.body)
    appLogger.info(output);

    // Write and send resonse
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.send(JSON.stringify(output));
    res.end();
});


// Decryption endpoint
app.post("/decrypting", (req, res) => {
    
    // Handle input message
    appLogger.info(`A new decryption request has come in`);
    let output = msgHandler.decryptMsg(req.body);
    appLogger.info(output);

    // Write and send resonse
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.send(JSON.stringify(output));
    res.end();
});


// Start server
appLogger.info("Starting server");
app.listen(process.env.PORT || 8000, process.env.IP || '0.0.0.0', () => {
    appLogger.info(`Server configured on Port '${port}', host '${host}'`);
});
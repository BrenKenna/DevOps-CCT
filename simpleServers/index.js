/**
 * Handle which server to run
 */

// Fetch required libs
const 
    Parser = require('./supporting/arg_parser/parser'),
    appLogger = require('./supporting/logging/appLogger'),
    MessageHandler = require('./supporting/messageHandler/MessageHandler')
;

// Configure cmd-line arg parser
const parser = new Parser();
parser.setDescription("Simple web server, for kubernetes tinkering with a Server-A & Server-B.");
parser.addArg("Server", "Which server to run", "-S,--server");
parser.updateGlobalVariables();
const server = parser.getGlobalArgumentValue("Server");
appLogger.info(`
Displaying Requested Server = '${server}'`);
appLogger.info(parser);


// Initialize message handler
appLogger.info("Initializing the message handler");
const msgHandler = new MessageHandler();
appLogger.info(msgHandler);


// Hash message
let msg, encMsg, decMsg, salt, hashedMsg, saltedHashMsg;
msg = 'hello';
salt = msgHandler.fetchSalt();
appLogger.info(`Generated Salt:
${salt}`);
hashedMsg = msgHandler.hashMsg(msg);
appLogger.info(`Generated hash of '${msg}':
${hashedMsg}`);
saltedHashMsg = msgHandler.hashMsgWithSalt(msg);
appLogger.info(saltedHashMsg);


// Encrypt message
appLogger.info("Encrypting message");
encMsg = msgHandler.encryptMsg(msg);
appLogger.info(encMsg);
encMsg = msgHandler.encryptMsg(msg);
appLogger.info(encMsg);


// Decrypt message
appLogger.info("Decrypting message");
decMsg = msgHandler.decryptMsg(encMsg.EncryptedMessage);
appLogger.info(decMsg);
decMsg = msgHandler.decryptMsg(encMsg.EncryptedMessage);
appLogger.info(decMsg);
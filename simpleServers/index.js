/**
 * Handle which server to run
 */

// Fetch parser
const Parser = require('./supporting/arg_parser/parser');
const parser = new Parser();

// Configure
let server;
parser.setDescription("Simple web server, for kubernetes tinkering with a Server-A & Server-B.");
parser.addArg("Server", "Which server to run", "-S,--server");
parser.updateGlobalVariables();
server = parser.getGlobalArgumentValue("Server");
console.log(`
Displaying Requested Server = '${server}'
Displaying parser:`);
console.dir(parser, { depth: null});
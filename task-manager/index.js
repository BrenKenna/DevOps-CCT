
const 
    buildServ = require('./server');
;


// Run the server!
const server = buildServ();
try {
    server.listen({ port: 80, host: '0.0.0.0' });
  }
  catch (err) {
    server.log.error(err);
    process.exit(1)
  }
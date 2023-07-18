
const 
    buildServ = require('./server');
;


// Run the server!
const server = buildServ();
try {
    server.listen({ port: 3000, host: '0.0.0.0' });
  }
  catch (err) {
    server.log.error(err);
    process.exit(1)
  }
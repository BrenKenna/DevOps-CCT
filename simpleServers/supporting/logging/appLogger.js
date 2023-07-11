// Import modules required for providing
//  the configured app logging
const 
    log4js = require('log4js')
    fs = require('fs');
;

// Read logging config
// const loggingConf = fs.readFileSync('./supporting/logging/log4j.properties.json');


// Provide logger
const logger = log4js.configure('./supporting/logging/log4j.properties.json');
const appLogging = logger.getLogger();
module.exports = appLogging;
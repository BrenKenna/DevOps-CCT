
const Task = require('./Model/task');

function build() {

    const fastify = require("fastify")({
        logger: true
    });

    // ToDo for DB
    const tasks = [];


    /**
     * 
     * throw new Error('msg')
     */
    fastify.get('/', async(req, resp) => {
        return {hello: 'world'};
    });

    fastify.post('/task', async (req, resp) => {
        if ( "title" in req.body && "description" in req.body ) {
            let task = new Task(req.body.title, req.body.description);
            tasks.push(task);
            resp.status(200)
            return task;
        }
        else {
            resp.status(422);
            return {message: 'Invalid input, please provide a title and description'};
        }
    });

    fastify.get('/tasks', async(req, resp) => {
        return tasks;
    });

        return fastify
}

module.exports = build;
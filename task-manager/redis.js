const { createClient } = require('redis');

async function saveToRedis(task) {
    const { REDIS_SERVER, REDIS_PORT } = process.env
    const client = createClient({
        url: `redis://${REDIS_SERVER}:${REDIS_PORT}`,
    });
    client.connect();
    taskJSON = {
        title: task.getTitle(),
        description: task.getDescription()
    };
    const redisTasks = await client.get('tasks') ?? '[]';
    const tasks = JSON.parse(redisTasks);
    tasks.push(taskJSON);
    client.set('tasks', JSON.stringify(tasks));
}

async function getTasksFromRedis() {
    const { REDIS_SERVER, REDIS_PORT } = process.env
    const client = createClient({
        url: `redis://${REDIS_SERVER}:${REDIS_PORT}`,
    });
    client.connect();
    const redisTasks = await client.get('tasks') ?? '[]';
    return JSON.parse(redisTasks);
}

module.exports = {saveToRedis, getTasksFromRedis};
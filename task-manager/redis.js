const { createClient } = require('redis');

async function saveToRedis(task) {
    const { REDIS_SERVER, REDIS_PORT, REDIS_PASS } = process.env
    const passDec = Buffer.from(REDIS_PASS, 'base64').toString('ascii');
    console.log(`Redis Password:\n${REDIS_PASS}\nRedis Decode Pass:\t${passDec}`);
    const client = createClient({
        url: `redis://${REDIS_SERVER}:${REDIS_PORT}`,
        auth_pass: `${passDec}`
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
    const { REDIS_SERVER, REDIS_PORT, REDIS_PASS } = process.env
    const passDec = Buffer.from(REDIS_PASS, 'base64').toString('ascii');
    console.log(`Redis Password:\t${REDIS_PASS}\nRedis Decode Pass:\t${passDec}`);
    const client = createClient({
        url: `redis://${REDIS_SERVER}:${REDIS_PORT}`,
        auth_pass: `${passDec}`
    });
    client.connect();
    const redisTasks = await client.get('tasks') ?? '[]';
    return JSON.parse(redisTasks);
}

module.exports = {saveToRedis, getTasksFromRedis};
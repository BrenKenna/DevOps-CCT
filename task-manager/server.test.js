/**
 * Test saving 1, and 2.
 * Test get without post gives empty
 * Test get with 1 save
 * 
 * https://github.com/fastify/fastify/blob/main/docs/Guides/Testing.md
 */


const
    { test } = require('tap'),
    build = require('./server'),
    Task = require('./Model/task')
;

// Test route
test('requests the "/" route', async t => {
  const app = build()

  const response = await app.inject({
    method: 'GET',
    url: '/'
  })
  t.equal(response.statusCode, 200, 'returns a status code of 200');
});


// Test getting empty task arr
test('test getting an empty task array', async t => {
    const app = build()
  
    const response = await app.inject({
      method: 'GET',
      url: '/tasks'
    })
    t.equal(response.statusCode, 200, 'returns a status code of 200');
    t.equal(JSON.parse(response.body).length, 0), "returns an empty array";
});


// Test posting a task
test('test posting a task', async t => {
    const app = build()
  
    const response = await app.inject({
      method: 'POST',
      url: '/task',
      body: {
        title: "hello",
        description: "I am a task"
      }
    })
    t.equal(response.statusCode, 200, 'returns a status code of 200');
    t.not(JSON.parse(response.body), null), "response should not be null";
});


// test fetching empty array
test('test fetching an empty array', async t => {
    const app = build();
    const response = await app.inject({
        method: "GET",
        url: "/tasks"
    });
    t.equal(JSON.parse(response.body).length, 0, "returns an empty array");
});
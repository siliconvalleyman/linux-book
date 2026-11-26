const { createServer } = require('node:http');

createServer((request, response) => {
    response.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8' });
    response.end('Node service ready\n');
}).listen(3000, '0.0.0.0');

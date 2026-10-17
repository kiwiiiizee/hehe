const fs = require('node:fs');
const http = require('node:http');
const path = require('node:path');

const port = Number(process.env.PORT || 8080);
if (!Number.isInteger(port) || port < 1024 || port > 65535) {
  throw new Error(`PORT must be an integer from 1024 to 65535 (received ${process.env.PORT})`);
}

const page = fs.readFileSync(path.join(__dirname, 'index.html'));
const server = http.createServer((req, res) => {
  if (req.url === '/health') {
    res.writeHead(200, { 'content-type': 'application/json; charset=utf-8' });
    res.end(JSON.stringify({ status: 'ok' }));
    return;
  }

  if (req.method !== 'GET' || (req.url !== '/' && !req.url.startsWith('/?'))) {
    res.writeHead(404, { 'content-type': 'text/plain; charset=utf-8' });
    res.end('Not found');
    return;
  }

  res.writeHead(200, {
    'content-type': 'text/html; charset=utf-8',
    'content-length': page.length,
  });
  res.end(page);
});

server.listen(port, '0.0.0.0', () => {
  console.log(`Demo website listening on 0.0.0.0:${port}`);
});

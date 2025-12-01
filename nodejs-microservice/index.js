const http = require('http');

const server = http.createServer((req, res) => {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello from Microservice');
});

const PORT = 80;
server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

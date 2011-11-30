// Constants
var PORT = 8060;

// Requires
var connect = require('connect');

var router = connect.router(function(app) {
  
  /**
   * Status Check
   *
   * @return {Object} Status {status: "ok"}
   */
  app.get('/', function(req, res) {
    res.writeHead(200, {
      'Content-Type': 'application/json'
    });
    res.write('{"status": "ok"}');
    res.end();
  });

  app.post('/client', function(req, res) {
    console.log('client-->', req.body);
  });

  app.post('/server', function(req, res) {
    console.log('server-->', req.body);
  });

});

var server = connect.createServer();

server.use(connect.bodyParser());
server.use(router);
server.listen(PORT);

console.log('Updater Ready');

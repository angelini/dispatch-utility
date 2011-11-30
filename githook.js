// Constants
var PORT = 8060;

// Requires
var connect = require('connect');
var spawn = require('child_process').spawn;

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

  app.post('/update', function(req, res) {
    if(req.body && req.body.payload) {
      var dispatch = spawn(__dirname + '/dispatch.sh', ['restart']);
    }
  });

});

var server = connect.createServer();

server.use(connect.bodyParser());
server.use(router);
server.listen(PORT);

console.log('Updater Ready');

(function() {
  var app, configure, express, socketio;

  express = require("express");

  configure = require("./configure");

  app = express.createServer();

  configure(app);

  socketio = require("./socket");

  socketio.start(app);

  app.get('/', function(req, res) {
    return res.render('index');
  });

  app.listen(3000);

}).call(this);

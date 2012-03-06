(function() {
  var RedisStore, app, chatty, configure, express, io, socketio;

  express = require("express");

  configure = require("./configure");

  chatty = require("./chatty");

  app = express.createServer();

  configure(app);

  socketio = require("socket.io");

  io = socketio.listen(app);

  RedisStore = socketio.RedisStore;

  io.set("store", new RedisStore);

  chatty(io);

  app.get('/', function(req, res) {
    return res.render('index');
  });

  app.listen(3000);

}).call(this);

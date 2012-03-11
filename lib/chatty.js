(function() {
  var Logger, chatty, events, logger, _;

  Logger = require("./logger");

  logger = new Logger({
    level: 4
  });

  events = require("./events");

  _ = require('underscore');

  module.exports = chatty = function(io, options) {
    var redis, store;
    options = _.extend({}, {
      port: 6379
    });
    if (io == null) io = require("socket.io".listen(80));
    redis = require("redis");
    try {
      store = redis.createClient(options.port);
    } catch (e) {
      store = new MemoryStore();
    }
    return io.sockets.on("connection", function(socket) {
      var event, handler, _ref, _results;
      _ref = events(socket, store);
      _results = [];
      for (event in _ref) {
        handler = _ref[event];
        _results.push(socket.on(event, handler));
      }
      return _results;
    });
  };

}).call(this);

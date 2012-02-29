(function() {

  module.exports.start = function(app) {
    var io;
    io = require('socket.io').listen(app);
    return io.sockets.on("connection", function(socket) {
      socket.emit("message", {
        message: "bar"
      });
      return socket.on("message", function(data) {
        socket.broadcast.emit("message");
        return socket.broadcast.json.send(data);
      });
    });
  };

}).call(this);

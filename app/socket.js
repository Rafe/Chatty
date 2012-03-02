(function() {
  var __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  module.exports.start = function(app) {
    var io, messages, users;
    io = require('socket.io').listen(app);
    messages = ["Test", "test2"];
    users = ["Jimmy", "Alan"];
    return io.sockets.on("connection", function(socket) {
      socket.on("message", function(message) {
        messages.push(message);
        socket.broadcast.emit("message");
        return socket.broadcast.json.send(message);
      });
      socket.on("user:join", function(user) {
        if (__indexOf.call(users, user) < 0) users.push(user);
        socket.emit("message:history", {
          "messages": messages,
          "users": users
        });
        return socket.broadcast.emit("user:join", user);
      });
      return socket.on("user:left", function(user) {
        var index;
        index = users.indexOf(user);
        if (index > 0) users.splice(index, index + 1);
        return socket.broadcast.emit("user:left");
      });
    });
  };

}).call(this);

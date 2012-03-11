(function() {
  var Logger, events, logger, pack, unpack, users, util, _;

  _ = require("underscore");

  users = {};

  pack = JSON.stringify;

  unpack = JSON.parse;

  util = require("./util");

  Logger = require("./logger");

  logger = new Logger({
    level: 4
  });

  module.exports = events = function(socket, store) {
    return {
      "message": function(message) {
        var user;
        if (!(socket.user != null)) {
          socket.emit("error", "User must login to post messages");
          return false;
        }
        user = socket.user;
        util.sanitize(message);
        store.lpush("room:" + user.room, pack(message));
        return socket.broadcast.to(user.room).emit("message", message);
      },
      "user:join": function(user, callback) {
        var queue, _name;
        if (users[_name = user.room] == null) users[_name] = {};
        socket.user = util.sanitize(user);
        queue = store.multi();
        if (!(user.id != null)) {
          queue.incr("user_id", function(error, id) {
            user.id = id;
            return users[user.room][user.id] = user;
          });
        }
        queue.lrange("room:" + user.room, 0, -1, function(error, messages) {
          return callback({
            "messages": _.map(messages, unpack),
            "users": users[user.room]
          });
        });
        return queue.exec(function() {
          socket.join(user.room);
          return socket.broadcast.to(socket.user.room).emit("user:join", user);
        });
      },
      "disconnect": function() {
        var user;
        if (socket.user == null) return;
        user = socket.user;
        if (users[user.room] != null) delete users[user.room][user.id];
        return socket.broadcast.to(user.room).emit("user:left", user);
      }
    };
  };

}).call(this);

(function() {
  var Message, User,
    _this = this;

  User = (function() {

    function User(name, room) {
      this.name = name;
      this.room = room;
    }

    return User;

  })();

  Message = (function() {

    function Message(user_id, user_name, text) {
      this.user_id = user_id;
      this.user_name = user_name;
      this.text = text;
      this.time = new Date().toString();
    }

    return Message;

  })();

  this.Chatty = {
    events: {
      "message": function(message) {
        return _this.set_message(message);
      },
      "user:join": function(user) {
        return _this.set_user(user);
      },
      "user:left": function(user) {
        _this.set("" + user.name + " left the room");
        return $("#user-" + user.id).remove();
      },
      "error": function(error) {
        return alert(error);
      }
    },
    bind: function(inputbox, chatbox, messagebox, usersbox) {
      var event, handler, _ref,
        _this = this;
      this.socket = io.connect("http://localhost:3000/");
      this.form = $(inputbox);
      this.chatbox = $(chatbox);
      this.message = $(messagebox);
      this.users = $(usersbox);
      _ref = this.events;
      for (event in _ref) {
        handler = _ref[event];
        this.socket.on(event, handler);
      }
      return this.form.submit(function(event) {
        var message;
        event.preventDefault();
        message = new Message(_this.user.id, _this.user.name, _this.message.val());
        _this.message.val("");
        _this.set_message(message);
        _this.socket.emit("message", message);
        return false;
      });
    },
    set: function(text) {
      return this.chatbox.append(text);
    },
    set_message: function(message) {
      return this.set("<p><strong>" + message.user_name + ":</strong> " + message.text + " at " + message.time + "</p>");
    },
    set_user: function(user) {
      this.set("<p>" + user.name + " Joined the room</p>");
      return this.users.append("<li id='user-" + user.id + "'>" + user.name + "</li>");
    },
    join: function(name, room) {
      var _this = this;
      this.user = new User(name, room);
      return this.socket.emit("user:join", this.user, function(data) {
        var id, message, user, _i, _len, _ref, _ref2, _results;
        _ref = data.messages;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          message = _ref[_i];
          _this.set_message(message);
        }
        console.log(data.users);
        _ref2 = data.users;
        _results = [];
        for (id in _ref2) {
          user = _ref2[id];
          _results.push(_this.set_user(user));
        }
        return _results;
      });
    }
  };

}).call(this);

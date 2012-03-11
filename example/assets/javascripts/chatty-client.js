(function() {
  var Chatty, Message, User,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

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
      this.time = new Date().toISOString();
    }

    return Message;

  })();

  Chatty = (function() {

    function Chatty() {
      this.events = __bind(this.events, this);
    }

    Chatty.prototype.events = function() {
      var _this = this;
      return {
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
      };
    };

    Chatty.prototype.bind = function(inputbox, chatbox, messagebox, usersbox) {
      var event, handler, _ref,
        _this = this;
      this.socket = io.connect("http://localhost:3000/");
      this.form = $(inputbox);
      this.chatbox = $(chatbox);
      this.message = $(messagebox);
      this.users = $(usersbox);
      _ref = this.events();
      for (event in _ref) {
        handler = _ref[event];
        this.socket.on(event, handler);
      }
      return this.form.submit(function(event) {
        var message;
        event.preventDefault();
        if (_this.message.val() === "") return;
        message = new Message(_this.user.id, _this.user.name, _this.message.val());
        _this.message.val("");
        _this.set_message(message);
        _this.socket.emit("message", message);
        return false;
      });
    };

    Chatty.prototype.message_template = _.template("<p><strong><%= user_name%>:</strong> <%= text %> in \n<abbr class='timeago' title='<%= time %>'/></p>");

    Chatty.prototype.user_template = _.template("<div id='user-<%=id %>' class='user span1 thumbnail'>\n  <img src='http://placehold.it/100x100'/>\n  <p><strong><%= name %></strong></p>\n</div>");

    Chatty.prototype.set = function(text) {
      return this.chatbox.prepend(text);
    };

    Chatty.prototype.set_message = function(message) {
      this.set(this.message_template(message));
      return $('abbr.timeago').timeago();
    };

    Chatty.prototype.set_user = function(user) {
      this.set("<p>" + user.name + " Joined the room</p>");
      return this.users.append(this.user_template(user));
    };

    Chatty.prototype.join = function(name, room) {
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
    };

    return Chatty;

  })();

  this.chatty = new Chatty();

}).call(this);

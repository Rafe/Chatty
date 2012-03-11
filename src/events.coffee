_ = require "underscore"
users = {}
pack = JSON.stringify
unpack = JSON.parse
util = require "./util"
Logger = require "./logger"
logger = new Logger level:4

module.exports = events = (socket,store)->

  "message": (message)->
    if not socket.user?
      socket.emit "error", "User must login to post messages"
      return false

    user = socket.user

    util.sanitize(message)

    store.lpush "room:#{user.room}",pack(message)
    socket.broadcast.to(user.room).emit "message", message


  "user:join":(user,callback)->
    users[user.room] ?= {}

    socket.user = util.sanitize(user)

    queue = store.multi()
    if not user.id?
      queue.incr "user_id",(error,id)->
        user.id = id
        users[user.room][user.id] = user

    queue.lrange "room:#{user.room}",0,-1,(error,messages)->
      callback
        "messages": _.map(messages,unpack)
        "users": users[user.room]
    queue.exec ()->
      socket.join user.room
      socket.broadcast.to(socket.user.room).emit "user:join", user

  "disconnect":()->
    return unless socket.user?
    user = socket.user
    delete users[user.room][user.id] if users[user.room]?
    socket.broadcast.to(user.room).emit "user:left", user

Logger = require "./logger"
logger = new Logger level:4

events = require "./events"

module.exports = chatty = (io,port)->
  redis = require "redis"
  store = redis.createClient(port)
  io.sockets.on "connection", (socket) ->
    for event,handler of events(socket,store)
      socket.on event, handler

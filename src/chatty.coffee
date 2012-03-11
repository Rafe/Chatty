Logger = require "./logger"
logger = new Logger level:4

events = require "./events"
_ = require 'underscore'

module.exports = chatty = (io, options)->

  options = _.extend {},
    port: 6379

  io ?= require "socket.io".listen 80

  redis = require "redis"
  store = redis.createClient(options.port)

  io.sockets.on "connection", (socket) ->
    for event,handler of events(socket,store)
      socket.on event, handler

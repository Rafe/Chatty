sio = require 'socket.io'
express = require 'express'
configure = require './configure'

app = express.createServer()

configure app



app.get '/', (req,res)->
  res.send "Hello World"

app.listen 3000

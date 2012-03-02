express = require "express"
configure = require "./configure"
chatty = require "./chatty"

app = express.createServer()

configure app
chatty app

app.get '/', (req,res) ->
  res.render 'index'

app.listen 3000

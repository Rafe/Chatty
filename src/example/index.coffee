express = require "express"
chatty = require "../lib/index"
app = express.createServer()

app.set 'view engine', 'jade'
app.set 'views', 'example/views'
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser()
app.use express.session({ secret: 'asdhki83y9ukjfkajhfkwhk1jdkeh1kda@jsadhFasdjh' })
app.use app.router
app.use express.static(__dirname + '/assets')

socketio = require "socket.io"
io = socketio.listen app

RedisStore = socketio.RedisStore
io.set("store", new RedisStore)

chatty io

app.get '/', (req,res) ->
  res.render 'index'

app.listen 3000

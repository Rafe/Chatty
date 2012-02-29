express = require "express"

module.exports = configure = (app) ->
  app.set 'view engine', 'jade'
  app.set 'views', 'app/views'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.session({ secret: 'asdhki83y9ukjfkajhfkwhk1jdkeh1kda@jsadhFasdjh' })
  app.use app.router
  app.use express.static(__dirname + '/assets')

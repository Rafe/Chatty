(function() {
  var app, chatty, configure, express;

  express = require("express");

  configure = require("./configure");

  chatty = require("./chatty");

  app = express.createServer();

  configure(app);

  chatty(app);

  app.get('/', function(req, res) {
    return res.render('index');
  });

  app.listen(3000);

}).call(this);

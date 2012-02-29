(function() {
  var configure, express;

  express = require("express");

  module.exports = configure = function(app) {
    app.set('view engine', 'jade');
    app.set('views', 'app/views');
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(express.cookieParser());
    app.use(express.session({
      secret: 'asdhki83y9ukjfkajhfkwhk1jdkeh1kda@jsadhFasdjh'
    }));
    app.use(app.router);
    return app.use(express.static(__dirname + '/assets'));
  };

}).call(this);

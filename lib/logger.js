(function() {
  var Logger, levels;

  levels = ['error', 'warn', 'info', 'debug'];

  module.exports = Logger = (function() {

    function Logger(options) {
      if (options == null) options = {};
      this.level = options.level || 3;
    }

    Logger.prototype.log = function(type, message) {
      var index;
      index = levels.indexOf(type);
      if (index > this.level) return this;
      return console.log(message);
    };

    return Logger;

  })();

  levels.forEach(function(name) {
    return Logger.prototype[name] = function(message) {
      return this.log(name, message);
    };
  });

}).call(this);

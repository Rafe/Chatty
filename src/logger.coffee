levels =[
  'error'
  'warn'
  'info'
  'debug'
]

module.exports = class Logger
  constructor: (options) ->
    options ?= {}
    @level = options.level || 3

  log:(type,message)->
    index = levels.indexOf(type)

    return this if index > this.level
    console.log(message)

levels.forEach (name)->
  Logger.prototype[name] = (message)->
    @log(name,message)

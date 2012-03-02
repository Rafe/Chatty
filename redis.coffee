redis = require "redis"

client = redis.createClient()

client.on "error", (err)->
  console.log err

client.set "test" , "test" , redis.print

client.get "test", redis.print

client.hset "hashtest", "good", 12, redis.print

client.hset ["hashtest", "bad", "Alan"], redis.print

client.hkeys "hashtest", (err, replies) -> 
  console.log replies.length + " replies:"
  replies.forEach (reply,i) ->
    console.log "   " + i + ": " + reply
  client.quit()

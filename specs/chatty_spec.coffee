class FakeSocket
  constructor:()->
    @stubs = {}
    @broadcast = @

  to:(room)->
    @

  emit:(event,data,callback)->
    @stubs[event] = data
    return true

class FakeStore
  constructor:()->
    @stubs = {}

  lpush:(channel,message)->
    @stubs[channel] = message

  multi:()->
    this

  incr:()->
    this

  lrange:()->
    this

  exec:()->
    this

  rpush:()->
    this

events = require "../lib/events"

users = {}

describe "chatty",()->
  beforeEach ()->
    @socket = new FakeSocket()
    @store = new FakeStore()
    @events = events(@socket,@store)

  it "should reject message if no user in socket",()->
    message_handler = @events["message"]
    expect(message_handler("test message")).toBe false

  describe "message event",()->

    beforeEach ()->
      @socket.user =
        id:13
        name:"Jimmy"
        room:1301
      @message =
        user_id : 13
        text: "test message"

    it "should save and broadcast message",()->
      spyOn(@store,"rpush")

      @events["message"](@message)

      expect(@socket.stubs["message"]).toEqual @message
      expect(@store.rpush).toHaveBeenCalled()

  describe "join event",()->
    beforeEach ()->
      spyOn(@store,"incr")
      spyOn(@store,"incr",true)
      spyOn(@store,"lrange")
      spyOn(@store,"exec")
      spyOn(@store,"multi").andReturn(@store)
      @user =
        name:"Jimmy"
        room:1301

    it "should call the store function and return user",()->
      @events["user:join"] @user, ()->{}
      
      expect(@store.incr).toHaveBeenCalled()
      expect(@store.lrange).toHaveBeenCalled()
      expect(@store.exec).toHaveBeenCalled()

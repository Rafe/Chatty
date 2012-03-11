* api style

  chatty = require "chatty"
  chatty.start() # run the message service on redis

  client-side:
    chatty.join(room_id,{
      on_message: "",
      join:"",
      left:"",
      history:""
    });

    chatty.history() # pass back json history

  listen /messages/:room_id

* user detect

* client restructure

* message structure

* test 

* upload to github and run as package

* move client to chatty-client/example project

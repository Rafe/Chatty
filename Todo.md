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

* user detect

* client restructure

* message structure

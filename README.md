#Chatty 

Chatty is a chat module under socket.io  
Implement the simple interaction of message service  
Use Redis to store message


##Usage:

* Server:

      var chatty = require("chatty");  
      var socketio = require("socket.io");

      io = socketio.listen("80");
      chatty(io);

* Client:

      <script src="/socket.io/socket.io.js"></script>
      <script src="http://code.jquery.com/jquery.min.js"></script>
      <script src="/javascripts/chatty-client.js">
        $(function(){
          chatty.bind("#chatbox");
          chatty.join("User Name","Room Name");
        });
      </script>


##Dependencies

* node.js
* socket.io
* coffee-script 
* redis 

client 

* jquery

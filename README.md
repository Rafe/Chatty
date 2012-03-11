#Chatty 

Chatty is a chat module under socket.io 
Implement the simple interaction of messaging service


##Usage:

* Server:

    var chatty = require("chatty");  

    chatty();

* Client:

    <script src="/socket.io/socket.io.js"></script>
    <script src="http://code.jquery.com/jquery.min.js"></script>
    <script src="/javascripts/chatty.js">
      $(function(){
        Chatty.bind("#chatbox");
        Chatty.join("User Name");
      });
    </script>


##Dependencies

* node.js
* socket.io
* coffee-script 
* redis 

client 

* jquery

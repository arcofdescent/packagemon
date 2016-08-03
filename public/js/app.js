
$(document).ready(function() {

  console.log('ready');

  // start a websocket server
  var ws = new WebSocket('ws://localhost:3000/echo');
  ws.onopen = function () {
    console.log('Connection opened');
  };

  ws.onmessage = function(msg) {
    console.log(msg.data);
  };

  /*
  $("#send").click(function() {
    ws.send('Please monitor my packages');
  });
  */

});



$(document).ready(function() {

  console.log('ready');

  var ws = new WebSocket('ws://localhost:3000/echo');
  ws.onopen = function () {
    console.log('Connection opened');
    //ws.send('Please monitor my packages');
  };

  ws.onmessage = function (msg) {
    console.log('msg received: ' + msg);
  };

  /*
  $("#send").click(function() {
    ws.send('Please monitor my packages');
  });
  */

});


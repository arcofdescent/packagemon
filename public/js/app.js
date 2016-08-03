
$(document).ready(function() {

  console.log('ready');

  // start a websocket server
  var ws = new WebSocket('ws://localhost:3000/echo');
  ws.onopen = function () {
    console.log('Connection opened');
  };

  ws.onmessage = function(msg) {
    console.log(msg.data);

    // probably not safe to use a regex, we should be receiving JSON
    var li_class;
    if (msg.data.match(/Installed/)) {
      li_class = 'installed';
    }
    else if (msg.data.match(/Removed/)) {
      li_class = 'removed';
    }

    $("#package_list").append('<li class="' + li_class + '">' + msg.data + '</li>'); 
  };

  /*
  $("#send").click(function() {
    ws.send('Please monitor my packages');
  });
  */

});


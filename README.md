# packagemon
webapp to monitor packages

## DESCRIPTION
This basically boils down to monitor a log file. In the case of deb based
distros this would be ***/var/log/dpkg.log***.

We first set up a websocet server in app.pl, thanks to **Mojolicious**.
***public/js/app.js*** connects and listens for messages and then adds entries
to the HTML. Simple enough.

Now for the file monitor. In ***bin/tail.pl*** we set up a damone using the 
Event module. At the same time **AnyEvent::WebSocket::Client** connects to the
websocet server. So, Event::File tails the logs file, parses the line, and send
the info via the websocket connection.

## INSTALLATION
  - CPAN modules
    - Mojolicious
    - Event
    - Event::File

  - Clone this repo
  - Run the Mojolicious app using morbo or hypnotoad
    - $ morbo app.pl
  - Start the daemon to monitor the log file
    - $ ./bin/tail.pl
  - Open you browser to http://localhost:3000/

  - This page will receive data in real time via the websocket connection about
    deb packages which have been installed/removed.


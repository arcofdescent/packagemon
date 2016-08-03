#!/usr/bin/perl
use strict; use warnings;
use 5.010;

# tail.pl
# -------
#   daemon to tail a file

use File::Tail;
use AnyEvent::WebSocket::Client;

my $log = '/var/log/dpkg.log';

my $client = AnyEvent::WebSocket::Client->new();

$client->connect("ws://localhost:3000/echo")->cb(sub {

    say "Connected";

    our $connection = eval { shift->recv };
    if ($@) {
      warn $@;
      return;
    }

    while (1) {
      $connection->send("Hello");
      sleep(2);
    }

    #$connection->on(each_message => sub {
    #my ($connection, $msg) = @_;
    #say "received from browser: $msg";
    #
    #});
    #$connection->close();

});

AnyEvent->condvar->recv;


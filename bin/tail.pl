#!/usr/bin/perl
use strict; use warnings;
use 5.010;
$|++;

# tail.pl
# -------
#   daemon to tail a file

use Event::File;
use AnyEvent::WebSocket::Client;

#my $log = '/var/log/dpkg.log';
my $client = AnyEvent::WebSocket::Client->new();
my $log = 't.log';

my $connection;
my @lines;

$client->connect("ws://localhost:3000/echo")->cb(sub {

    $connection = eval { shift->recv };
    if ($@) {
      die $@;
      return;
    }

    # start tailing
    tail_the_log();


    #$connection->on(each_message => sub {
    #my ($connection, $msg) = @_;
    #say "received from browser: $msg";
    #
    #});
    #$connection->close();

});

sub tail_the_log {
  Event::File->tail(
    file => $log,
    cb => sub {
      my ($e, $line) = @_;
      $connection->send($line);
      #push @lines, $line;
    },
    timeout => 5,
  );
}

Event::loop;

#AnyEvent->condvar->recv;

sub parse_log_line {
  my ($line) = @_;
  my ($date, $time, $status, $status_2, $package) = split / /, $line;

  return $line;
}


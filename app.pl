#!/usr/bin/perl
use strict; use warnings;
use 5.010;

use Mojolicious::Lite;

my %clients;

get '/' => sub {
  my $c = shift;

  $c->render('index');
};

websocket '/echo' => sub {
  my $c = shift;

  $c->app->log->debug('Client connected: ' . $c->tx);
  my $id = sprintf "%s", $c->tx;
  $clients{$id} = $c->tx;

  $c->on(message => sub {
      my ($self, $msg) = @_;
      #$c->app->log->debug("Received message: $msg");

      # send to all clients, which includes the ws in our app.js
      for (keys %clients) {
        $clients{$_}->send('ecgo :' . $msg);
      }
  });

  $c->on(finish => sub {
      $c->app->log->debug('Client disconnected');
      delete $clients{$id};
    
  });

};

app->start;


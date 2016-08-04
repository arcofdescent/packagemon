#!/usr/bin/perl
use strict; use warnings;
use 5.010;

# tail.pl
# -------
#   daemon to tail a file and send parsed info to a websocket server

use Event::File;
use AnyEvent::WebSocket::Client;

my $log = '/var/log/dpkg.log';
my $client = AnyEvent::WebSocket::Client->new();
#my $log = './t/sample.log';

my $connection;

# track unpacked packages which will be installed 
my %installed_packages;

$client->connect("ws://localhost:3000/echo")->cb(sub {

    $connection = eval { shift->recv };
    if ($@) {
      die $@;
      return;
    }

    # start tailing
    tail_the_log();
});

sub tail_the_log {
  Event::File->tail(
    file => $log,
    cb => sub {
      my ($e, $line) = @_;
      my $info = parse_log_line($line);

      if ($info) {
        my $msg;

        if ($info->{status} eq 'installed') {
          $msg = $info->{date_time} . ' - Installed ' . $info->{package};
        }
        elsif ($info->{status} eq 'remove') {
          $msg = $info->{date_time} . ' - Removed ' . $info->{package};
        }

        $connection->send($msg);
      }
    },
    timeout => 5, # watch the file every 5 seconds
  );
}

Event::loop;

sub parse_log_line {
  my ($line) = @_;
  my ($date, $time, $status, $status_2, $package) = split / /, $line;

  # packages are first unpacked and then installed. Track them.
  if ($status_2 eq 'unpacked') {
    $installed_packages{$package} = 1; 
    return;
  }

  if ($status_2 eq 'installed') {
    # this package should be unpacked first
    if ($installed_packages{$package}) {
      # we got a package
      delete $installed_packages{$package};
      return {
        status => $status_2,
        package => $package,
        date_time => join(' ', $date, $time),
      };
    }
  }

  if ($status eq 'remove') {
    return {
      status => $status,
      package => $status_2,
      date_time => join(' ', $date, $time),
    };
  }

  return;
}


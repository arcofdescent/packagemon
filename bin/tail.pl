#!/usr/bin/perl
use strict; use warnings;
use 5.010;

# tail.pl
# -------
#   daemon to tail a file

use File::Tail;

my $log = '/var/log/dpkg.log';



#!/usr/bin/perl
# Watch a channel for joins (you know, to punce and stuff)
# In the future expand this to be generic notification
# instead of e-notify-send
# and to be able to watch for a specific user (stalking :P)

use strict;
use warnings;
use Irssi;

my @watched;
my @people;
# Just some seed channels for now
push @watched, "#iit-acm";
push @people, "ChrisLAS";

sub add_channel {
   my ($chan) = @_;
   if ($chan =~ m/:?(#\w+)/){
      push @watched, $chan;
   }
   elsif ($chan =~ m/\w*/){
      push @people, $1;
   }
   Irssi::print "watching $chan";
}

sub list_watched {
   foreach (@watched) {
      Irssi::print $_;
   }
}

sub rem_channel {
   my @ind = grep { $watched[$_] eq $_[0] } 0..$#watched;
   foreach (@ind) {
      splice (@watched, $_, 1);
   }
}

sub notify_join {
   my ($server, $channel, $nick, $address) = @_;
   $channel =~ s/:?(#\w+)/$1/;
   if ( grep(/$channel/, @watched) or grep(/$nick/, @people) )  {
      open(COMMAND, "e-notify-send $channel $nick >/dev/null |");
   }
}

Irssi::signal_add("event join", 'notify_join');
Irssi::command_bind('watch', 'add_channel');
Irssi::command_bind('unwatch', 'rem_channel');
Irssi::command_bind('watched', 'list_watched');

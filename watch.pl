#!/usr/bin/perl
# Watch a channel for joins (you know, to punce and stuff)
# In the future expand this to be generic notification
# instead of e-notify-send
# and to be able to watch for a specific user (stalking :P)

use strict;
use warnings;
use Irssi;

my @channels;
my @people;

sub add_channel {
   my ($name) = @_;
   if ($name =~ m/:?(#[\w-]+)/){
      push @channels, $1;
   }
   elsif ($name =~ m/\w*/){
      push @people, $name;
   }
   Irssi::print "watching $name";
}

sub list_watched {
   foreach (@channels) {
      Irssi::print $_;
   }
   foreach (@people) {
      Irssi::print $_;
   }
}

sub rem_channel {
   $_[0] =~ m/:?(#?[\w_]+)/;
   @channels = grep { not $_ eq $1; } @channels;
   @people = grep { not $_ eq $1 } @people;
}

sub notify_join {
   my ($server, $channel, $nick, $address) = @_;
   $channel =~ s/:?(#\w+)/$1/;
   $nick =~ s/([\w_]+)/$1/;
   if ( grep(/$channel/, @channels) or grep(/$nick/, @people) )  {
      open(COMMAND, "e-notify-send join \"$channel $nick\" >/dev/null |");
   }
}

sub notify_leave {
   my ($server, $channel, $nick) = @_;
   $channel =~ s/:?(#\w+)/$1/;
   $nick =~ s/([\w_]+)/$1/;
   if ( grep(/$channel/, @channels) or grep(/$nick/, @people) )  {
      open(COMMAND, "e-notify-send quit \"$channel $nick\" >/dev/null |");
   }
}


Irssi::signal_add("event join", 'notify_join');
Irssi::signal_add("event part", 'notify_leave');
Irssi::command_bind('watchfor', 'add_channel');
Irssi::command_bind('unwatch', 'rem_channel');
Irssi::command_bind('watching', 'list_watched');

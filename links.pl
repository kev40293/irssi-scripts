#!/usr/bin/perl
#
# Plugin to Irssi to allow commands to keep track of links posted in
# the channels and also to open links in an external browser
#
# Copyright (C) 2012  Kevin Brandstatter
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
# USA.

use Irssi;
my @list;
sub sub_priv {
	my ($server, $data, $nick, $address) = @_;
	my ($target, $text) = split(/ :/, $data, 2);
	# learn too accomadate multiple links in comment
	my  @tokens = split(' ', $text);
	foreach (@tokens){
		if (/(http[s]?:\/\/[\/\w\.,\?&=#_\-\%]*)/s){
			Irssi::print("Added $1");
			push @list, $1;
		}
	}
}
sub print_list {
	Irssi::print "Links:";
	my $counter = $#list;
	foreach (@list){
		Irssi::print "$counter: $_";
		$counter--;
	}
}
sub go_to {
	my ($ind) = @_;
	my $link;
	if ($ind <= $#list){
		$link = $list[$#list-$ind];
	}	
	else {
		$link = $list[0];
	}

	if ($link ne ""){
		open(COMMAND, "xdg-open $link 2>&1 >/dev/null |");
	}
}
sub clear_list {
	undef @list;
}
sub rm_link {
	my ($ind) = @_;
	my $link = $list[$#list-$ind];
	if (defined $link){
		#splice(@links, $ind, 1);
		undef $list[$#list-$ind];
	}
	else {
		Irssi::print("No link specified");
	}
}

# TODO add help information in the irssi way

Irssi::signal_add("event privmsg", 'sub_priv');
Irssi::command_bind('linklist', 'print_list');
Irssi::command_bind('openlink', 'go_to');
Irssi::command_bind('clearlink', 'clear_list');
Irssi::command_bind('rmlink', 'rm_link');

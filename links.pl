#!/usr/bin/perl
#

use Irssi;
use URI::Escape;
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
Irssi::signal_add("event privmsg", 'sub_priv');
Irssi::command_bind('linklist', 'print_list');
Irssi::command_bind('openlink', 'go_to');

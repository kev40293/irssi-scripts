#!/usr/bin/perl
#
# Plugin to Irssi to allow commands to keep track of links posted in
# the channels and also to open links in an external browser
#
# Copyright (C) 2013  Kevin "icarus" Brandstatter, "nogal"
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
use strict;
use Irssi;
Irssi::signal_add({
		'redir run_kick_user' => 'kick_user',
		'redir run_kick_failed' => 'kick_fail'
	});

sub request_whois {
	my ($server, $nick) = @_;
	$server->redirect_event
	(
		'whois', 1, $nick, 0,
		'redir run_kick_fail', # error handler
		{
			'event 311' => 'redir run_kick_user' # event mappings
		}
	);
#			'event 318' => 'redir test_redir_whois_end',
#			'event 319' => 'redir test_redir_whois_channels',
#			'event 401' => 'redir test_redir_whois_nosuchnick',
#			'' => 'event empty',
#		}
#	);
	#Irssi::print("Sending Command: WHOIS $name", MSGLEVEL_CLIENTCRAP)
	#	if $debug;
	#send the actual command directly to the server, rather than # with $server->command()
	$server->send_raw("WHOIS $nick");
}
sub kick_fail(){
	Irssi::print("Failed to kick");
}

sub kick_user (){
	my ($server, $data) = @_;
	my ($nick, $user, $host) = ( split / +/, $data, 6)[1,2,3];
	$server->command("MODE +b *!*@" . $host);    # send command
	$server->command("KICK $nick message");    # send kick command
	#if ($host =~ /((?:[0-9]{1,3}\.){3}[0-9]{1,3})/){
		#$server->command("MODE +b *!*@ $1");    # send command
		#$server->command("KICK $name message");    # send kick command
		#	Irssi::print("ip = $1");
		#}
		#else{
		#Irssi::print("No IP match : $host");
		#}
}



sub gtfo() {
	my ($name) = @_;
	my $server = Irssi::active_server();

	if (!$server || !$server->{connected}){
		Irssi::print("Not connected to server");
	}
	else {
		request_whois($server, $name);
	}
}

Irssi::command_bind('gtfo', 'gtfo');

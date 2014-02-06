#!/usr/bin/perl -w

use strict;
use IO::Socket; #For accessing sockets.
use Term::ANSIColor qw(:constants); #For changing terminal colours.

$SIG{CHLD}='IGNORE'; #Destroys Zombie Child Processes.

#Declare Variables.
my $kpid;
my $in;
my $out;
my $host;
my $port;
my $name;
my $socket;
my $s;

#Choose Settings.
&clear;

&blue ("Please Enter your Screen Name...\n\nScreen Name: ");
$name = <STDIN>;
chomp $name;
&clear;

&blue ("Please Enter the Host Address...\n\nAddress: ");
$host = <STDIN>;
chomp $host;
&clear;

&blue ("Please Enter the Host Port...\n\nPort: ");
$port = <STDIN>;
chomp $port;
&clear;

sub clear #clears the screen.
{
system ('clear');
}

sub ping #rings the terminal bell.
{
print STDERR BOLD, RED, "PING PING!!!\a\n", RESET;
}

sub blue #prints text in blue.
{
print STDERR BLUE, "@_", RESET;
}

sub green #prints text in green.
{
print STDERR GREEN,"@_", RESET;
}

sub red #prints text in red.
{
print STDERR BOLD, RED, "@_", RESET;
}

sub client #Client Section.
{


die "Couldn't Start the Chat Program: $!\n" unless defined($kpid = fork());

	if ($kpid)
	{
		&clear;
		&green("Connection established client, Please Chat!\n\n");
		
		while (defined ($in = <$socket>)) #Listen on the socket
		{
			if ($in eq "/quit\n") #If received is equal to quit, quit.
			{
				&red ("\nChat Ended\n\n");
				kill 1, $kpid;
				exit;
			}
			elsif ($in eq "/ping\n") #If received is equal to /ping, do ping sub.
			{
				&ping;
			}
			else
			{
				&blue ("#$in"); #Prints received information from socket.
			}
		}
			kill("TERM", $kpid); #terminate the child process.
	}
	else
	{
		while (defined ($out = <STDIN>)) #print too the socket.
		{
			if ($out eq "/quit\n") #If output is equal to quit, send "quit" without the nickname and quit.
			{
				
				print $socket "$out";
				&red ("\nChat Ended\n\n");;
				close $socket;
				kill 1, $kpid;
			}
			elsif ($out eq "/ping\n") #If received is equal to /ping, send "/ping" without the nickname.
			{
				print $socket "$out";
			}
			else
			{
				print $socket "$name: $out"; #Prints through the socket.
			}
		}
		
	}


} #End of Sub.
	
sub server #Server Section.
{
my $server = IO::Socket::INET->new( #creates server with 
LocalAddr => $s,
LocalPort =>$port,
Listen => 1,
Reuse => 1);

die "Could not create the chat session: $!\n" unless $server;

&clear;
&red ("waiting for a connection on $port...\n\n");

	while ($socket = $server->accept())
	{
		die "Can't fork: $!" unless defined($kpid = fork());
		
		if ($kpid)
		{
			&clear;
			&green("Connection established server, Please Chat!\n\n");
			
			while (defined ($out = <STDIN>)) #print down the socket.
			{
				if ($out eq "/quit\n")
				{
					print $socket "$out";
					&red ("\nChat Ended\n\n");
					close $socket;
					kill 1, $kpid;
					exit;
				}
				elsif ($out eq "/ping\n")
				{
					print $socket "$out";
				}
				else
				{
					print $socket "$name: $out";
				}
			}
		}
		else
		{
			while (defined ($in = <$socket>)) #Print from the socket.
			{
				if ($in eq "/quit\n")
				{
					&red ("\nChat Ended\n\n");
					close $socket;
					kill 1, $kpid;
					exit;
				}
				elsif ($in eq "/ping\n")
				{
					&ping;
				}
				else
				{
					&blue ("#$in");
				}
					
			}
			close $socket;
			exit;
		}
		close $socket;
	}
} #End of Sub.


$socket = IO::Socket::INET->new("$host:$port"); #Socket test for client connection.

if ($socket) #preforms test, and connects, otherwise creates server.
{

	&client;
}
else
{
	&server;
}

__END__

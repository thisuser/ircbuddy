package Ircbuddy::Dynamic::Help;

use strict;
use warnings;

my %help = (
	learn => "Learn a definition. syntax:  learn <term>: <definintion>",
	relearn => "Relearn a definition. syntax: relearn <term>: <definition>",
	forget  => "Deleted a definition. syntax: forget <term>",
	search => "Searches the glossary. syntax: search <term>",
	question => "Question Builder. This feature enables you to build a multiple choice question. To start, type: new multiple choice question",
	register => "register with me so you can help contribute",
	auth => "Authenticate with me:  auth <password>",
);

sub go {
    my (undef,$self,$mess) = @_;

	my $message = $mess->{body};
	if ($message =~ /^help$/) {
		my @all = keys (%help);

		$self->reply($mess,join(', ',@all) . ". More help is available:  help <topic>");
	}
	if ($message =~ /^help\s+\S+/) {
		my ($thing) = ($message =~ /^help\s+(\S+)/);
		if (exists $help{$thing}) {
			$self->reply($mess,$help{$thing});
		}
		else {
			$self->reply($mess,"No help on that");
		}
	}


}


1;

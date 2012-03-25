package Ircbuddy;

use File::Copy;
use Module::Loaded;
use FindBin::Real;


use lib FindBin::Real::Bin() .'/lib';
use Database::Main;

#
# zOMG I left a password!
my $schema = Database::Main->connect('dbi:mysql:cisco:localhost', 'cisco', 'ciscostuffs') or die $!;

use Module::Find;

use Class::Inspector;



my @core  =  useall Ircbuddy::Core;
my @active = useall Ircbuddy::Dynamic;

print "$_\n" for @core;
print "$_\n" for @active;

my $core_commands = Class::Inspector->methods('Ircbuddy::Core::Core','private');
s/^_// for @{ $core_commands };
    

use base qw/Bot::BasicBot/;

  my $bot = Ircbuddy->new(

    server => "irc.freenode.net",
    port   => "6667",
    channels => ["#ircbuddy"],

    nick      => "ircbuddy2",
    alt_nicks => ["ircbuddy_", "ircbuddy__"],
    username  => "ircbuddy",
    name      => "ircbuddy",

#    ignore_list => [qw(Chanserv)];

  );

sub said {
  
  my $self = shift;
  my $mess = shift;
  print STDERR $mess->{who} ." : ".$mess->{body}."\n";
  my $nick = $self->nick;
  
  if (exists $mess->{address}) {
	my $message = $mess->{body};
	
	if (is_loaded("Ircbuddy::Dynamic::Dispatch")) {
	eval { Ircbuddy::Dynamic::Dispatch->dispatch($self,$mess,$schema) };
	  $self->reply($self,$mess,$@) if $@;
	}
	else {
	  $self->reply($mess,"I don\'t know what to do.. my Dispatch module is not loaded :(");
	}
  }
}


sub help {
	my $self = shift;
	my $mess = shift;

	if (is_loaded("Ircbuddy::Dynamic::Help")) {
		eval { Ircbuddy::Dynamic::Help->go($self,$mess) };
		$self->reply($mess,$@) if $@;
	}
	else {
		$self->reply($mess,"Help module is not loaded");
	}
}
	
$bot->run();


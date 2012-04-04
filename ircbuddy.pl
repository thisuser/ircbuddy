package Ircbuddy;


use Module::Loaded;
use Module::Find;
use FindBin::Real;
use lib FindBin::Real::Bin() .'/lib';
use Database::Main;



# zOMG I left a password!.. and I don't care!
my $schema = Database::Main->connect('dbi:mysql:cisco:localhost', 'cisco', 'ciscostuffs') or die $!;

#Load all our modules
my @core  =  useall Ircbuddy::Core;
my @active = useall Ircbuddy::Dynamic;
print "$_\n" for @core;
print "$_\n" for @active;



use base qw/Bot::BasicBot/;

  my $bot = Ircbuddy->new(

    server => "irc.freenode.net",
    port   => "6667",
    channels => ["#ircbuddy"],

    nick      => "ircbudtest123",
    alt_nicks => ["ircbudtest1", "ircbudtest_"],
    username  => "ircbudtest",
    name      => "ircbuddy",

#    ignore_list => [qw(Chanserv)];

  );

sub said {
  
  my $self = shift;
  my $mess = shift;
  print STDERR $mess->{who} ." : ".$mess->{body}."\n";
  my $nick = $self->nick;
  
  
  # if the bot is addressed
  if (exists $mess->{address}) {
	
	my $message = $mess->{body};
	
	
	# Check to see if what is sent to ircbuddy is
	# an actual command. If it's not, send the message
	# to the Quiz module because it may be a response
	# to a question.
	if (is_loaded("Ircbuddy::Dynamic::Dispatch")) {
	  my ($check) = ($message =~ /(\S+)/);
	  my %hash = Ircbuddy::Dynamic::Dispatch->get_hash;
	  if (exists $hash{$check}) {
		
		# It is a command, send it to Dispatch
		eval { Ircbuddy::Dynamic::Dispatch->dispatch($self,$mess,$schema) };
		$self->reply($mess,$@) if $@;  # Exception, send error message to channel
	  }
	  # not a command, if it ends in a ?, send it to quiz
  	  elsif ($message =~ /.*\?$/) {
		if (is_loaded("Ircbuddy::Dynamic::Quiz")) {
		  eval { Ircbuddy::Dynamic::Quiz->go($self,$mess,$schema) };
		  $self->reply($mess,$@) if $@;  # Exception, send error message to channel
		}
	  }
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


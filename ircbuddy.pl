package Ircbuddy;


use Module::Loaded;
use Module::Find;
use FindBin::Real;
use lib FindBin::Real::Bin() .'/lib';
use Database::Main;


my $ai;


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

    nick      => "ircbuddy" . ( int( rand( 999)) + 123),
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
	  $check = lc $check;
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
	  else {
		  # do nothing
		  return;
		  
	  }
	}
	else {
	  $self->reply($mess,"I don\'t know what to do.. my Dispatch module is not loaded :(");
	
	}
  }
  else {
	# AI stuff!  Ircbuddy wants in on the conversation!
	  if (is_loaded(Ircbuddy::Dynamic::DispatchAI)) {
		eval { Ircbuddy::Dynamic::DispatchAI->dispatch($self,$mess,$schema,$ai)};
		$self->reply($mess,$@) if $@;  # Exception, send error message to channel
	  }
  }
}

sub chanjoin {
  
  my ($self,$mess) = @_;
  my $who = $mess->{who};
  
  
  return if $self->nick eq $who;
  
  if (!exists $ai->{"chanjoin"}{$who}) {
	my $time = time;
	
	  # it's been a while since ircbuddy saw this person
		my @random = (
            "hi " . $who,
			"hi",
            "hey " . $who,
            
        );
        my $rand = int rand @random;
		$ai->{"chanjoin"}{ $who } = $time;
		$ai->{said_hi}{ $who } = time;
		delete $mess->{"who"};
		$bot->say(channel=> $mess->{channel}, body => $random[$rand]);
		

        
	
	
  }
  else {
	return;
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
sub tick {
    my $self = shift;
	my $time = time;
	
	if (exists $ai->{said_hi}) {

	  for my $who (keys %{ $ai->{said_hi}}) {
		
		delete $ai->{said_hi}{$who} if ( ($time - $ai->{said_hi}{$who}) > 600); # 10 minutes
	  }
	}
	if (exists $ai->{chanjoin}) {
	  for my $who (keys %{ $ai->{chanjoin}}) {
		
		delete $ai->{chanjoin}{$who} if ( ($time - $ai->{chanjoin}{$who}) > 3600); #  an hour
	  }
		
	}


    return 5;
}
	
$bot->run();


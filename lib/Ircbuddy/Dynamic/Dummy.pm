package Ircbuddy::Dynamic::Dummy;

use strict;
use warnings;

use Ircbuddy::Core::Tools qw/ _randomip /;

sub go {
    
    my ($self,$bot,$mess,$schema) = @_;
    
    my $message = $mess->{body};
    my $ip = _randomip();
    $bot->reply($mess,$ip);
}

1;
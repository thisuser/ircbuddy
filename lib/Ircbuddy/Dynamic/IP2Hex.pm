package Ircbuddy::Dynamic::IP2Hex;

use strict;
use warnings;


sub go {
    
    my ($self,$bot,$mess,$schema) = @_;
    
    my $message = $mess->{body};
        if ($message =~ /^ip2hex\s+\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/) {
                my ($one,$two,$three,$four) = ($message =~ /^ip2hex\s+(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})/);
                $bot->reply($mess,sprintf("%X.%X.%X.%X",$one,$two,$three,$four));
        }

}

1;
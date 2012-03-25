package Ircbuddy::Dynamic::Dummy;

use strict;
use warnings;



sub go {
    
    my ($self,$bot,$mess,$schema) = @_;
    $bot->reply($mess,"works");

}

1;
package Ircbuddy::Dynamic::Logout;

use strict;
use warnings;
use Crypt::PasswdMD5;

sub go {

    my ($self,$bot,$mess,$schema) = @_;
    my $message = $mess->{body};
    
    
    my $update = $schema->resultset('Users')->search({ username => lc $mess->{who}, raw_nick => $mess->{raw_nick} })->update({ raw_nick => '' });
        if ($update) {
            $bot->reply($mess,"done");
        }
}


1;
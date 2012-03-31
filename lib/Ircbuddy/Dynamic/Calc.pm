package Ircbuddy::Dynamic::Calc;

use WWW::Google::Calculator;
use strict;
use warnings;

sub go {

    my ($self,$bot,$mess) = @_;
    my $message = $mess->{body};
    if ($message =~ /^calc\s+\S+/) {
        my ($stuff) = ($message =~ /^calc\s+(.*)/);
        my $calc = WWW::Google::Calculator->new;
        my $output = $calc->calc($stuff);
        if (length $output) {
                $bot->reply($mess,$output);
        }
        else {
                $bot->reply($mess,"dunno");
        }
    }


}
1;

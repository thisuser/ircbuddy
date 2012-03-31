package Ircbuddy::Dynamic::How;

# To search the table command_reference;

use strict;
use warnings;



sub go {

    my ($self,$bot,$mess,$schema) = @_;
    my $message = $mess->{body};
    if ($message =~ /^how\s+(can|do)\s+i/i) {
        my (undef,$problem) = ($message =~ /^how\s+(can|do)\s+i\s+(.*?)\?*$/);

        my $search = $schema->resultset('CommandReference')->search({ problem => $problem});

        if ($search->count) {
                my $solution = $search->first->solution;
                my (@lines) = split(/\\n|\|/,$solution);
                for my $each (@lines) {
                    $bot->reply($mess,$each);
                }
        }
        else {
                $bot->reply($mess,"I don\'t know how");
        }
   }
}

1;

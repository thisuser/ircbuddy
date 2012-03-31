package Ircbuddy::Dynamic::You;

# To add entries to the table command_reference

use strict;
use warnings;



sub go {

    my ($self,$bot,$mess,$schema) = @_;
    my $message = $mess->{body};
    if ($message =~ /^you\s+can\s+.*by\s+\S+/i) {
        my ($problem,$solution) = ($message =~ /^you\s+can\s+(.*)\s+by\s+(.*)/);

        my $insert = $schema->resultset('CommandReference')->create({ problem => $problem, solution => $solution});

        if ($insert->id) {
                $bot->reply($mess,"Thanks, added");
        }
        else {
                $bot->reply($mess,"There was an error :(");
        }
   }
}

1;

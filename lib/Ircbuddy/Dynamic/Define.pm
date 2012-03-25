package Ircbuddy::Dynamic::Define;

use strict;
use warnings;




sub go {
    my ($self,$bot,$mess,$schema) = @_;

	my $message = $mess->{body};
    if ($message =~ /^define\s+\S+/i) {

		my ($term) = ($message =~ /define\s+(.*)/);
        my $search = $schema->resultset('Glossary')->search({ term => $term});
        if ($search->count) {

            my $first = $search->first;
            $bot->reply($mess,$first->definition);
        }
        else {
            $bot->reply($mess,"I don\'t know how");
        }
    }


}


1;

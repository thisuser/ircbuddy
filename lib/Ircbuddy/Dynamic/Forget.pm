package Ircbuddy::Dynamic::Forget;

use strict;
use warnings;




sub go {
    my ($self,$bot,$mess,$schema) = @_;

	my $message = $mess->{body};
        if ($message =~ /^forget\s+.*?/i) {
                my ($term) = ($message =~ /^forget\s+(.*)/);
                if (length $term) {
                        my $search = $schema->resultset('Glossary')->search({ term => $term});
                        if ($search->count) {
                                $search->delete;
                                $bot->reply($mess,"forgotten!");
                        }
                        else {
                                $bot->reply($mess,"oops! something happened $term ");
                        }
                }
                else {
                        $bot->reply($mess,"forget what?");
                }
        }



}


1;

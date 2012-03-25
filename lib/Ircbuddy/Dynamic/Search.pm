package Ircbuddy::Dynamic::Search;

use strict;
use warnings;




sub go {
    my ($self,$bot,$mess,$schema) = @_;

	my $message = $mess->{body};
        if ($message =~ /^search\s+\S+/) {
                my ($term) = ($message =~ /^search\s+(.*)/);
                $term =~ s/\"//g;
                $term =~ s/\'//g;
                $term =~ s/^\s+//;
                $term =~ s/\s+$//;

                my $search = $schema->resultset('Glossary')->search({ -or => [
                        definition => { -like => '%' .$term .'%'  },
                        term       => { -like => '%' .$term .'%'  },
                ],

                });
                my @results;
                if ($search->count == 0) {
                        $bot->reply($mess,"I found nuttin\'");
                }
                elsif ($search->count < 25) {
                        while(my $row = $search->next) {
                                push(@results,$row->term);
                        }
                        my $found = join(', ',@results);
                        $bot->reply($mess,"I found $found ");
                }
                else {
                        $bot->reply($mess,"Too many results");
                }
        }


}


1;

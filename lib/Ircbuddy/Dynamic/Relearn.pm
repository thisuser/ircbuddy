package Ircbuddy::Dynamic::Relearn;

use strict;
use warnings;




sub go {
    my ($self,$bot,$mess,$schema) = @_;

	my $message = $mess->{body};
        if ($message =~ /^relearn\s+.*?:\s+?\S/i) {
                my ($term,$definition) = ($message =~ /relearn\s+(.*?):\s+?(.*)/);

                my $search = $schema->resultset('Glossary')->search({ term=> $term})->update({definition => $definition});
                if ($search) {
                        $bot->reply($mess,"Thanks, updated");
                }
                else {
                        $bot->reply($mess,"I don\'t know what $term is");
                }
        }



}


1;

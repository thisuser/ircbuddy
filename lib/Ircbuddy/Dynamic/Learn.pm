package Ircbuddy::Dynamic::Learn;

use strict;
use warnings;




sub go {
    my ($self,$bot,$mess,$schema) = @_;

	my $message = $mess->{body};
	
    if ($message =~ /^learn\s+.*?:\s+?\S/i) {
        my ($term,$definition) = ($message =~ /learn\s+(.*?):\s+?(.*)/);
        $term =~ s/^\s+//;  # Remove space at the beginning
        $term =~ s/\s+$//;  # Remove space at the end
		
        my $check = $schema->resultset('Glossary')->search({ term => $term});
        if ($check->count) {
            $bot->reply($mess,"I already know what that is");
        }
        else {
            my $insert = $schema->resultset('Glossary')->create({ term=> $term, definition => $definition});
            if ($insert->id) {
                $bot->reply($mess,"Thanks, added");
            }
            else {
                $bot->reply($mess," oops! something happened :( ");
            }
        }
	}


}


1;

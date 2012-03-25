package Ircbuddy::Dynamic::ListDefines;

use strict;
use warnings;




sub go {
    my ($self,$bot,$mess,$schema) = @_;

	my $message = $mess->{body};
        if ($message =~ /^listdefines/) {
                my $page;
                if ($message =~ /^listdefines$/) {
                        $page = 1;
                }
                if ($message =~ /^listdefines\s+\d+/) {
                        ($page) = ($message =~ /^listdefines\s+(\d+)/);
                }
                my $search = $schema->resultset('Glossary')->search(undef, { rows => 10, order_by => 'term' })->page($page);
                if ($search->count) {
                        my @words;
                        while(my $row = $search->next) {
                                push(@words,$row->term);
                        }
                        my $join = join(', ',@words);
                        $bot->reply($mess,"[page $page] $join");
                }
                else {
                        $bot->reply($mess,"no more definitions");
                }
        }


}


1;

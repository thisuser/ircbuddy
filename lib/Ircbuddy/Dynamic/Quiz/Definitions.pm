package Ircbuddy::Dynamic::Quiz::Definitions;
use strict;
use warnings;


sub quiz {
    
    my ($self,$schema) = @_;
    
    my $all = $schema->resultset('Glossary')->search;
    my @random;
    if ($all->count) {
        while(my $row = $all->next) {
            push(@random,$row->gid);
        }
        my $size = @random;
        my $rand = int rand $size;

        my $id = $random[$rand];

        my $search = $schema->resultset('Glossary')->find($id);
    
    
        my $question = $search->definition;
        my $answer   = $search->term;
    
        my @array = ($question,$answer);
        return @array;
    
    }
    else {
        return 0;
    }
}





1;

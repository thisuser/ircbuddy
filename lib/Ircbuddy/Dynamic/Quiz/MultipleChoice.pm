package Ircbuddy::Dynamic::Quiz::MultipleChoice;
use strict;
use warnings;


use List::Util 'shuffle';




sub quiz {
        my ($self,$schema) = @_;


        my $all = $schema->resultset('MCQuestions')->search;
        my @random;
        if ($all->count) {
            while(my $row = $all->next) {
                push(@random,$row->mc_id);
            }
            my $size = @random;
            my $rand = int rand $size;

            my $id = $random[$rand];


            my $search = $schema->resultset('MCQuestions')->find($id);

            if ($search) {
                my $question = $search->question;
                my @answers = ($search->answer =~ /(\d+)/g);

                my $options = $schema->resultset('MCOptions')->search({ parent_id => $id });
                my @ids;
                my $hash = {};
                while(my $row = $options->next) {
                    push(@ids,$row->mco_id);
                    $hash->{$row->mco_id}{option} = $row->options;
                }
                my @shuffled = shuffle(@ids);
                my $x = 1;
                my @correct; # acceptable answers
                for my $each (@shuffled) {
                    my $letter = $x;
                    $letter =~ s/1/a/;
                    $letter =~ s/2/b/;
                    $letter =~ s/3/c/;
                    $letter =~ s/4/d/;
                    $letter =~ s/5/e/;
                    $letter =~ s/6/f/;
                    $letter =~ s/7/g/;
                    $letter =~ s/8/h/;
                    push(@correct,$letter) if grep($_ == $each, @answers);
                    $x++;
                }
                # output to channel
                #$mess->{address} = 0;
                my $answer = join (',',@correct);
                #$self->reply($mess,"#" .$id .")" .$question);
                my $y = 1;
                for my $each (@shuffled) {
                    my $letter = $y;
                    $letter =~ s/1/a/;
                    $letter =~ s/2/b/;
                    $letter =~ s/3/c/;
                    $letter =~ s/4/d/;
                    $letter =~ s/5/e/;
                    $letter =~ s/6/f/;
                    $letter =~ s/7/g/;
                    $letter =~ s/8/h/;
                    $y++;
                    $question .= "\n" .$letter .") " . $hash->{$each}{option};

                }
                my @array = ($question,$answer);
                return @array;
            }

        }

}



1;

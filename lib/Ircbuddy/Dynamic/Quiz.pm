package Ircbuddy::Dynamic::Quiz;

use strict;
use warnings;

use List::MoreUtils qw(pairwise);


use Ircbuddy::Dynamic::Quiz::Subnetting;
use Ircbuddy::Dynamic::Quiz::Bin2Hex;
use Ircbuddy::Dynamic::Quiz::Definitions;




my $quiz;
my $question;
my $answer;


sub go {
    
    my ($self,$bot,$mess,$schema) = @_;
    my $message = $mess->{body};
    my $who;
    
    if ($mess->{channel} eq 'msg') {
        $who = $mess->{who};
    }
    else {
        $who = 'ircbuddy'; # Channel
    }
    
    # Ends in a question mark,
    # so is it an attempt to answer a question?
    if ($message =~ /.*\?$/) {
        my ($try) = ($message =~ /(.*)\?$/);
        
        if (exists $quiz->{$who}{answer}) {   
            my $answer = $quiz->{$who}{answer};
            if ($try =~ /^$answer$/i) {
                $bot->reply($mess,"correct!");
                delete $quiz->{$who};
                        
            }
            else {
                $bot->reply($mess,"nope :(");
            }
        }
       
    }
    elsif ($message =~ /^repeat$/) {
        if (exists $quiz->{$who}{question}) {
            $bot->reply($mess,$quiz->{$who}{question});
        }
        else {
            $bot->reply($mess,"no pending question");
        }

    }
    elsif ($message =~ /^quiz\s+(me|us)\s+on\s+def(initions)?/i) {
        
        
        ($question,$answer) = Ircbuddy::Dynamic::Quiz::Definitions->quiz($schema);
        $quiz->{$who}{question} = $question;
        $quiz->{$who}{answer}   = $answer;
         $bot->reply($mess,$question); 
        

    }
    elsif ($message =~ /^quiz\s+(me|us)\s+on\s+subnet(ting)?/i) {
       
       
       ($question,$answer) = Ircbuddy::Dynamic::Quiz::Subnetting->quiz;
        $quiz->{$who}{question} = $question;
        $quiz->{$who}{answer}   = $answer;
        $bot->reply($mess,$question);    
        
    }
    elsif ($message =~ /^quiz\s+(me|us)\s+on\s+(bin2hex|binary\s+to\s+hex)$/i) {
       
       
       ($question,$answer) = Ircbuddy::Dynamic::Quiz::Bin2Hex->quiz;
        $quiz->{$who}{question} = $question;
        $quiz->{$who}{answer}   = $answer;
        $bot->reply($mess,$question);    
        
    }
    elsif ($message =~ /^quiz\s+(me|us)\s+on\s+multiple\s+choice$/i) {
       
       
       ($question,$answer) = Ircbuddy::Dynamic::Quiz::MultipleChoice->quiz($schema);
        $quiz->{$who}{question} = $question;
        $quiz->{$who}{answer}   = $answer;
        if ($mess->{channel} ne 'msg') {
            delete $mess->{who};
        }
        
        $bot->reply($mess,$question);    
        
    }
    elsif ($message =~ /^i\s+give\s+up$/i) {
        
        if (exists $quiz->{$who}) {
            
            $bot->reply($mess,"answer: ". $quiz->{$who}{answer});
            delete $quiz->{$who};
        }
        else {
            $bot->reply($mess,"No pending question");
        }
        
        
    }
    elsif ($message =~ /^quiz\s+new\s+(ccna|ccent):.*:\s+?\S+/i) {
        
        my ($level,$question,$answer) =~ /^quiz\s+new\s+(ccna|ccent)\s+?:(.*)\s+?:\s+?(.*)/i;
        $bot->reply($mess,"level: $level, question: $question, answer: $answer");
    }
    
    else {
        $bot->reply($mess,"Unknown quiz command");
    }

        



    
}

1;
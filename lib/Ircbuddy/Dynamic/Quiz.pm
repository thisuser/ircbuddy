package Ircbuddy::Dynamic::Quiz;

use strict;
use warnings;

use List::MoreUtils qw(pairwise);
use Ircbuddy::Core::Tools qw/ _randomip _dec2bin _bin2dec /;


my $quiz;


sub go {
    
    my ($self,$bot,$mess,$schema) = @_;
    my $message = $mess->{body};
    if ($message =~ /.*\?$/) {
        my ($try) = ($message =~ /(.*)\?$/);
        
        if ($mess->{channel} eq 'msg') {
        
            my $answer = $quiz->{$mess->{who} }{answer};
            if ($try =~ /^$answer$/) {
                $bot->reply($mess,"correct!");
                delete $quiz->{$mess->{who} };
                        
            }
            else {
                $bot->reply($mess,"nope :(");
            }
        }
        else {
            my $answer = $quiz->{ircbuddy}{answer};
            if ($try =~ /^$answer$/) {
                $bot->reply($mess,"correct!");
                delete $quiz->{ircbuddy};
            }
        }
       
    }
    elsif ($message =~ /^quiz\s+(me|us)\s+on\s+subnet(ting)?/i) {
        
        my $ip = &_randomip;
        my $prefix = (int rand 25) + 8;

        # mask in binary
        my $ones = $prefix;
        my $zeros = 32 - $prefix;
        my $binary_mask = 1 x $ones . 0 x $zeros;
        my @mask = split('',$binary_mask);

        # IP in binary
        my @octets = map{_dec2bin($_) } split('\.',$ip);
        my $join = join('',@octets);
        my @ipaddr = split('',$join);


        my @network = pairwise { $a & $b } @mask,@ipaddr;
        my $network_binary = join('',@network);
        my @network_octets = ($network_binary =~ /(\d{8})/g);
        my @decimals = map{ _bin2dec($_) } @network_octets;
        
        my $question = "Given $ip/$prefix, network address is?";
        my $answer = join('.',@decimals);
        
        if ($mess->{channel} eq 'msg') {   #private message
            
            $quiz->{ $mess->{who} }{question} = $question;
            $quiz->{ $mess->{who} }{answer}   = $answer;
                
        }
        else {
            $quiz->{ircbuddy}{question} = $question;
            $quiz->{ircbuddy}{answer}   = $answer;
        }
        $bot->reply($mess,$question);
        
    }
    elsif ($message =~ /^repeat$/) {
        if ($mess->{channel} eq 'msg') {
            if (exists $quiz->{$mess->{who}}{question}) {
                $bot->reply($mess,$quiz->{$mess->{who}}{question});
            }
            else {
                $bot->reply($mess,"no pending question");
            }
        }
        else {
            if (exists $quiz->{ircbuddy}{question}) {
                $bot->reply($mess,$quiz->{ircbuddy}{question});
            }
            else {
                $bot->reply($mess,"no pending question");
            }
        }
    }

    
}

1;
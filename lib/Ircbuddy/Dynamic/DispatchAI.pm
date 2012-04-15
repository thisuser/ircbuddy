package Ircbuddy::Dynamic::DispatchAI;

use strict;
use warnings;
use Module::Loaded;




sub dispatch {
    my ($self,$bot,$mess,$schema,$ai) = @_;
    my $message = $mess->{body};
    
    my $nick = $bot->nick;
    
    if ($message =~ /^(hi|hey|sup)$/i) {
        
        my @random = (
            "hi " . $mess->{who},
            "sup?",
            "hey",
            "what\'s up?",
            "yo",
            "hey " . $mess->{who},
            
        );
        my $rand = int rand @random;
        if (!exists $ai->{said_hi}{$mess->{who}}) {
            $ai->{said_hi}{ $mess->{who} } = time;
            $bot->reply($mess,$random[$rand]);

        }
    }
    elsif ($message =~ /^(hi|hey|sup)\s+$nick$/) {
        my @random = (
            "hi " . $mess->{who},
            "sup?",
            "hey",
            "what\'s up?",
            "yo",
            "hey " . $mess->{who},
            
        );
        my $rand = int rand @random;
        if (!exists $ai->{said_hi}{$mess->{who}}) {
            $ai->{said_hi}{ $mess->{who} } = time;
            $bot->reply($mess,$random[$rand]);

        }
        
    }
 
}

    

1;


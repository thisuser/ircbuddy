package Ircbuddy::Core::Load;

use strict;
use warnings;

use Class::Runtime;


sub go {

    my ($self,$bot,$mess) = @_;
    my $message = $mess->{body};
    if ($message =~ /^load\s+\S+/) {
        my ($module) = ($message =~ /^load\s+(\S+)/);
        $module = ucfirst $module;
        
              

        my $Bin = FindBin::Real::Bin();

        if (-e $Bin ."/lib/Ircbuddy/Dynamic/$module\.pm") {
            
            $bot->reply($mess, "Already available");
        }
        elsif (-e $Bin ."/lib/Ircbuddy/Disabled/$module\.pm") {
            move($Bin."/lib/Ircbuddy/Disabled/$module\.pm" , $Bin."/lib/Ircbuddy/Dynamic/$module\.pm");
            my $load = "Ircbuddy::Dynamic::$module";
            eval "use $load; return 1";
            if (!$@) {
                $bot->reply($mess,"I just loaded $module for you");
            }
            else {
                $bot->reply($mess,$@);
            }
        }
    }
    else {
        $bot->reply($mess, "syntax: load <module>");
   }

}
1;
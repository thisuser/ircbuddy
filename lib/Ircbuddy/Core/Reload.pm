package Ircbuddy::Core::Reload;

use strict;
use warnings;

use Class::Runtime;


sub go {


    my ($self,$bot,$mess) = @_;
    my $message = $mess->{body};

    my ($module) = ($message =~ /^reload\s+(\S+)/);    
    

        
    $module = ucfirst $module;
    my $reload = "Ircbuddy::Dynamic::$module";

    my $Bin = FindBin::Real::Bin();

    if (-e $Bin ."/lib/Ircbuddy/Dynamic/$module\.pm") {
        my $cr = Class::Runtime->new( class => $reload);
        $cr->unload;
        eval "use $reload; return 1";
        if (!$@) {
            $bot->reply($mess,"I just reloaded $module for you");
        }
        else {
            $bot->reply($mess,$@);
        }
    }
    else {
        $bot->reply($mess,"module unknown or not loaded");
    }
}
1;
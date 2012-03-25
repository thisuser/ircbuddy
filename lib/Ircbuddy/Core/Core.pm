package Ircbuddy::Core::Core;

use strict;
use warnings;
use FindBin::Real;
use File::Copy;
use Class::Runtime;

sub _list {
    my (undef,$self,$mess) = @_;
    my $message = $mess->{body};
    
    if ($message =~ /^list\s+(disabled|dis|avail|available)$/i) {
        use Module::Find;
        setmoduledirs( FindBin::Real::Bin() .'/lib/Ircbuddy');
        my @found = findsubmod Disabled;
        s/Disabled::// for @found;
        $self->reply($mess,join(", ",@found) );
        #$self->reply($mess,FindBin::Real::Bin());
    }
    else {
        $self->reply($mess,"syntax: list (disabled|dis|avail|available)");
    }
}

sub _load {
    my (undef,$self,$mess) = @_;
    my $message = $mess->{body};
    if ($message =~ /^load\s+\w+/) {
        my ($module) = ($message =~ /^load\s+(\S+)/);
        $module = ucfirst $module;
        
        

        my $Bin = FindBin::Real::Bin();

        if (-e $Bin ."/lib/Ircbuddy/Dynamic/$module\.pm") {
            $self->reply($mess, "Already available");
        }
        elsif (-e $Bin ."/lib/Ircbuddy/Disabled/$module\.pm") {
            move($Bin."/lib/Ircbuddy/Disabled/$module\.pm" , $Bin."/lib/Ircbuddy/Dynamic/$module\.pm");
            my $load = "Ircbuddy::Dynamic::$module";
            eval "use $load; return 1";
            if (!$@) {
                $self->reply($mess,"I just loaded $module for you");
            }
            else {
                $self->reply($mess,$@);
            }
        }
    }
    else {
        $self->reply($mess, "syntax: load <module>");
    }
}
sub _unload {
    my (undef,$self,$mess) = @_;
    if ($mess->{body} =~ /^!unload\s\w+/) {
        my ($module) = ($mess->{body} =~ /^!unload\s(\w+)/);
        $module = ucfirst $module;

        my $Bin = FindBin::Real::Bin();

        if (-e $Bin ."/Modules/Disabled/$module\.pm") {
            $self->reply($mess, "Already disabled");
        }
        elsif (-e $Bin ."/Modules/Active/$module\.pm") {
            my $cr = Class::Runtime->new( class => $module);
            $cr->unload;
            move($Bin."/Modules/Active/$module\.pm" , $Bin."/Modules/Disabled/$module\.pm");

            eval "use $module; return 1";
            if ($@) {
                $self->reply($mess, $mess->{who} .": I just unloaded $module for you");
            }
            else {
                $self->reply($mess, $mess->{who} .": error unloading $module")
            }
        }
    }
    else {
        $self->reply($mess, "!unload <module>");
    }
}
        
1;
    


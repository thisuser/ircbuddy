package Ircbuddy::Dynamic::Dispatch;

use strict;
use warnings;
use Module::Loaded;


my %dispatch = (
    
    auth => {
        module => "Ircbuddy::Dynamic::Auth",
        where => "private",
    },
    authlevel => {
        module => "Ircbuddy::Dynamic::AuthLevel",
        auth => [qw/ admin /],
    },
    test => {
        module => "Ircbuddy::Dynamic::Dummy",
        
    },
    load => {
        module => "Ircbuddy::Core::Load",
        auth => [qw/ admin /],
        
    },
    reload => {
        module => "Ircbuddy::Core::Reload",
        auth => [qw/ admin /],
    },
    unload => {
        module => "Ircbuddy::Core::Unload",
        auth => [qw/ admin /],
    },
    ping => {
        module => "Ircbuddy::Dynamic::Ping",
    },
    
    register => {
        module => "Ircbuddy::Dynamic::Register",
        where => "private",
    },
    password => {
        module => "Ircbuddy::Dynamic::Register",
        where => "private",
    },

    logout => {
        module => "Ircbuddy::Dynamic::Logout",
        auth => [qw/admin moderator contributor /],
    },
    

    
    
    define => {
        module => "Ircbuddy::Dynamic::Define",
    },
    learn => {
        module => "Ircbuddy::Dynamic::Learn",
        auth => [qw/ admin moderator contributor /],
    },
    listdefines => {
        module => "Ircbuddy::Dynamic::ListDefines",
    },
    relearn => {
        module => "Ircbuddy::Dynamic::Relearn",
        auth => [qw/ admin moderator /],
    },
    forget => {
        module => "Ircbuddy::Dynamic::Forget",
        auth => [qw/ admin moderator /],
    },
    search => {
        module => "Ircbuddy::Dynamic::Search",
    
    },
    stats => {
        module => "Ircbuddy::Dynamic::Stats",
        auth => [qw/ admin moderator contributor /],
    },
    quiz => {
        module => "Ircbuddy::Dynamic::Quiz",
    },
);


sub dispatch {
    my ($self,$bot,$mess,$schema) = @_;
    my ($first) = ($mess->{body} =~ /^(\S+)/);
    my $key = lc $first;
    
    if (exists  $dispatch{$key}) {
        my $module = $dispatch{$key}{'module'};
        if (is_loaded($module)) {
            
            
            if (exists $dispatch{$key}{auth}) {
                
                
                
                my $who = $mess->{who};
                my $raw = $mess->{raw_nick};
                
                
                # Check if user exists
                my $search = $schema->resultset('Users')->search({ username => $who });
                
                if ($search->count) {
                    my $user = $search->first;
                  
                    if ($user->raw_nick eq $raw) {
                        my $role = $user->role;
                        
                        
                        if (grep($_ eq $role,  @{ $dispatch{$key}{auth} })) {
                        
  
                            if (exists $dispatch{$key}{'where'}) {
                                
                                if (
                                    ($mess->{channel} eq 'msg' && $dispatch{$key}{where} eq 'private') ||
                                    ($mess->{channel} ne 'msg' && $dispatch{$key}{where} eq 'channel')) {
     
                                    eval{ $module->go($bot,$mess,$schema) };
                                    $bot->reply($mess,$@) if $@;
                                }
                                else {
                                    $bot->reply($mess,"That function is limited to ".$dispatch{$key}{where}. " message");
                                }
                            }
                            else {

                                eval{ $module->go($bot,$mess,$schema) };
                                $bot->reply($mess,$@) if $@;
                            }
                        }
                        else {
                            
                            $bot->reply($mess,"Insufficient privileges");
                        }
                    }
                    else {
                        $bot->reply($mess,"That request requires authorization");
                        
                    }
                }
                else {
                    $bot->reply($mess,"That request requires registration and privileges");
                    
                }
            }
            else {
                # Anyone can use this module! fun fun!
                if (exists $dispatch{$key}{'where'}) {
                    if (
                        ($mess->{channel} eq 'msg' && $dispatch{$key}{where} eq 'private') ||
                        ($mess->{channel} ne 'msg' && $dispatch{$key}{where} eq 'channel')) {
     
                        eval{ $module->go($bot,$mess,$schema) };
                        $bot->reply($mess,$@) if $@;
                    }
                    else {
                        $bot->reply($mess,"That function is limited to ".$dispatch{$key}{where}. " message");
                    }
                }
                else {
                    eval{ $module->go($bot,$mess,$schema) };
                    $bot->reply($mess,$@) if $@;
                }
               
            }
        }
        else {
            $bot->reply($mess,"that module is not loaded");
        }
    }
    else {
        $bot->reply($mess,"?");
    }
    
    
    
}
1;


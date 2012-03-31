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
    broadcast => {
        module => "Ircbuddy::Dynamic::Broadcast",
    },
    calc => {
        module => "Ircbuddy::Dynamic::Calc",
    },

    hex2bin => {
        module => "Ircbuddy::Dynamic::Hex2Bin",
    },
    hex2dec => {
        module => "Ircbuddy::Dynamic::Hex2Dec",
    },
    how => {
        module => "Ircbuddy::Dynamic::How",
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

    },
    define => {
        module => "Ircbuddy::Dynamic::Define",
    },
    
    message => { # later tell?
        module => "Ircbuddy::Dynamic::Message",
        auth => [qw/ admin moderator contributor /],
    },
    messages => {
        module => "Ircbuddy::Dynamic::Message",
        auth => [qw/ admin moderator contributor /],
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
    network => {
        module => "Ircbuddy::Dynamic::Network",
        
    },
    repeat => {
        module => "Ircbuddy::Dynamic::Quiz",
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
    you => {
        module => "Ircbuddy::Dynamic::You",
        auth => [qw/ admin moderator contributor /],
   },

);

sub get_hash {
    return %dispatch;
}


sub dispatch {
    my ($self,$bot,$mess,$schema) = @_;
    my ($first) = ($mess->{body} =~ /^(\S+)/);
    my $key = lc $first;
    
    if (exists  $dispatch{$key}) {
        my $module = $dispatch{$key}{'module'};
        if (is_loaded($module)) {
            
            
            if (exists $dispatch{$key}{auth}) {
                # If we're here, then the module requires the
                # user to have a certain role to use it.
                
                
                my $who = $mess->{who};
                my $raw = $mess->{raw_nick};
                
                
                # Check if user exists in the database
                my $search = $schema->resultset('Users')->search({ username => $who });
                
                if ($search->count) {
                    my $user = $search->first;
                  
                  
                    # If raw_nick in the database matches the user's raw (ident@host)
                    # then the user is authenticated
                    if ($user->raw_nick eq $raw) {
                      
                      
                        # Get the user role, and see if it matches
                        # the module's requirement
                        my $role = $user->role;
                        if (grep($_ eq $role,  @{ $dispatch{$key}{auth} })) {
                            
                            # yay! we got this far, the user: exists, is authenticated, and
                            # has the correct role
                        
  
                            if (exists $dispatch{$key}{'where'}) {
                                # If were are here, the module requires the user request to
                                # be chatted in a specific way, like either channel, or private message
                                
                                if (
                                    ($mess->{channel} eq 'msg' && $dispatch{$key}{where} eq 'private') ||
                                    ($mess->{channel} ne 'msg' && $dispatch{$key}{where} eq 'channel')) {
     
                                    eval{ $module->go($bot,$mess,$schema) };
                                    $bot->reply($mess,$@) if $@; # Exception, reply with error
                                }
                                else {
                                    $bot->reply($mess,"That function is limited to ".$dispatch{$key}{where}. " message");
                                }
                            }
                            else {
                                # 'where' is not specified by the module,
                                # so just do it

                                eval{ $module->go($bot,$mess,$schema) };
                                $bot->reply($mess,$@) if $@; # Exception, reply with error
                            }
                        }
                        else {
                            # User exists, is authenticated, but does not
                            # have the correct role
                            $bot->reply($mess,"Insufficient privileges");
                        }
                    }
                    else {
                        # The user exists, but is not authenticated,
                        # raw_nick does not match user<ident@hostname>
                        $bot->reply($mess,"That request requires authorization");
                        
                    }
                }
                else {
                    # user is not in database at all
                    $bot->reply($mess,"That request requires registration and privileges");
                    
                }
            }
            else {
                # The module is wide open. Anyone can use this module! fun fun!
                if (exists $dispatch{$key}{'where'}) {
                    
                    #
                   
                    if (
                        ($mess->{channel} eq 'msg' && $dispatch{$key}{where} eq 'private') ||
                        ($mess->{channel} ne 'msg' && $dispatch{$key}{where} eq 'channel')) {
     
                        eval{ $module->go($bot,$mess,$schema) };
                        $bot->reply($mess,$@) if $@; # Exception, reply with error
                    }
                    else {
                        $bot->reply($mess,"That function is limited to ".$dispatch{$key}{where}. " message");
                    }
                }
                else {
                    eval{ $module->go($bot,$mess,$schema) };
                    $bot->reply($mess,$@) if $@; # Exception, reply with error
                }
               
            }
        }
        else {
            $bot->reply($mess,"that module is not loaded");
        }
    }
    else {
        # Unknown command
        $bot->reply($mess,"?");
    }
    
    
    
}
1;


package Ircbuddy::Dynamic::AuthLevel;

use strict;
use warnings;
use Crypt::PasswdMD5;

sub go {

    my ($self,$bot,$mess,$schema) = @_;
    my $message = $mess->{body};

 
    if ($message =~ /^authlevel\s+\S+\s+(admin|moderator|contributor)/i) {
    
    # get the user who is doing the command
  
        my ($user,$newrole) = ($message =~ /^authlevel\s+(\S+)\s+(\S+)/);
        $user = lc $user;
        $newrole = lc $newrole;
        # see if that user exists;
        my $search = $schema->resultset('Users')->search({ username => $user });
        if ($search->count) {
            $search->update({ role => $newrole });
            $bot->reply($mess,"Updated $user with $newrole role");
        }
        else {
            $bot->reply($mess,"That user would need to register first before being assigned a role");
        }
    }
    else {
        $bot->reply($mess,"syntax: authlevel <user> <admin|moderator|contributor>");
    }
}
1;
package Ircbuddy::Dynamic::Auth;

use strict;
use warnings;
use Crypt::PasswdMD5;

sub go {

    my ($self,$bot,$mess,$schema) = @_;
    my $message = $mess->{body};

 
    if ($message =~ /^auth(enticate)?\s+\S+/) {
        my (undef,$password) = ($message =~ /^auth(enticate)?\s+(\S+)/);

        my $search = $schema->resultset('Users')->search({
                        username => lc $mess->{who}
        });
        if ($search->count == 1) {
            my $row = $search->first;
            my $stored = $row->password;

             if ($stored eq unix_md5_crypt($password,$stored)) {

                $search->update({ raw_nick => $mess->{raw_nick} });
                my $raw = $mess->{raw_nick};
                $bot->reply($mess,"You are authenticated. If your identification changes from ($raw), you must authenticate again");
            }
            else {
                $bot->reply($mess,"Authentication failed");
            }
        }
        else {
            $bot->reply($mess,"You are not registered");
        }

    }


}
1;
package Ircbuddy::Dynamic::Register;

use strict;
use warnings;
use Crypt::PasswdMD5;

my $register;
sub go {

    my ($self,$bot,$mess,$schema) = @_;
    
    my $message = $mess->{body};
    
  
    if ($message =~ /^register$/) {
               
        $bot->reply($mess,qq/Hello, you are registering with me to participate in ##ccna-study. You need to define a password. Considering I am a bot and everything that is messaged to me is printed to the console (STDOUT), please choose a password that you wouldn't mind my administrator seeing./);
        $bot->reply($mess,"Set your password using the syntax:  password <password>");
        $register->{ $mess->{raw_nick} } = time;
        
    }
    elsif ($message =~ /^password\s+\S+/ && exists $register->{$mess->{raw_nick}}) {
        my ($password) = ($message =~ /^password\s+(\S+)/);
        my $encrypted = unix_md5_crypt($password);
        
        my $count = $schema->resultset('Users')->search({ username => lc $mess->{who} })->count;
        if ($count > 0) {
            $bot->reply($mess,qq/Your username is already registered in my database. Talk to infrared if you feel that is invalid./);
        }
        else {
            my $insert = $schema->resultset('Users')->create({ username => lc $mess->{who}, password => $encrypted });
            if ($insert->id) {
                my $whoadmin = $schema->resultset('Users')->search({ role => 'admin' });
                my @admins;
                while(my $row = $whoadmin->next) {
                    push(@admins,$row->username);
                }
                my $join = join(', ',@admins);
                $bot->reply($mess,qq/Thanks for registering! To authenticate, use the syntax:  auth <password>. I will keep track of you by remembering $mess->{raw_nick}/);        
                $bot->reply($mess,qq/The following users can assign permissions to your account so you may contribute: $join/);            
            }
            else {
                $bot->reply($mess,"Error :(   Please tell infrared!");
            }
        }
    }

}
1;
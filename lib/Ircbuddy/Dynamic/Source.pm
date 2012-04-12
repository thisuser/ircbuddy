package Ircbuddy::Dynamic::Source;


sub go {

    my ($self,$bot,$mess) = @_;
    $bot->reply($mess,"https://github.com/infrared/ircbuddy");
    

}
1;
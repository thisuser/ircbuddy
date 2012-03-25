package Ircbuddy::Dynamic::Ping;


sub go {

    my ($self,$bot,$mess) = @_;
    $bot->reply($mess,"pong");
    

}
1;
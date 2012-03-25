package Ircbuddy::Dynamic::Hex2Dec;


sub go {

    my ($self,$bot,$mess) = @_;
    my $message = $mess->{body};
        if ($message =~ /^(hex2dec|hex\s+to\s+dec|hex\s+to\s+decimal)\s+(\S+)$/) {
                my (undef,$hex) = ($message =~ /^(hex2dec|hex\s+to\s+dec|hex\s+to\s+decimal)\s+(\S+)$/);
                $bot->reply($mess,hex $hex);
        }


    

}
1;
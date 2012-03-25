package Ircbuddy::Dynamic::Hex2Bin;


sub go {

    my ($self,$bot,$mess) = @_;
    my $message = $mess->{body};
            if ($message =~ /^hex2bin\s+(\S+)/) {
                my ($hex) = ($message =~ /^hex2bin\s+(\S+)/);
                $hex = hex $hex;
                my $binary = _dec2bin_nibble($hex);
                $bot->reply($mess,$binary);
        }

    

}
1;
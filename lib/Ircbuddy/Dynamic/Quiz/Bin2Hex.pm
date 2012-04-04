package Ircbuddy::Dynamic::Quiz::Bin2Hex;

use strict;
use warnings;

use Ircbuddy::Core::Tools qw/ _dec2bin /;

sub quiz {
    
    
    
    my $random = int rand 256;
    my $binary = _dec2bin($random);
    my$answer = uc sprintf("%x", $random);
    my $question = "Binary $binary converted to hex is?";
    my @array = ($question,$answer);
    return @array;



}





1;

package Ircbuddy::Dynamic::Quiz::Subnetting;
use strict;
use warnings;

use List::MoreUtils qw(pairwise);
use Ircbuddy::Core::Tools qw/ _randomip _dec2bin _bin2dec /;



sub quiz {
    
        my $ip = &_randomip;
        my $prefix = (int rand 25) + 8;

        # mask in binary
        my $ones = $prefix;
        my $zeros = 32 - $prefix;
        my $binary_mask = 1 x $ones . 0 x $zeros;
        my @mask = split('',$binary_mask);

        # IP in binary
        my @octets = map{_dec2bin($_) } split('\.',$ip);
        my $join = join('',@octets);
        my @ipaddr = split('',$join);


        my @network = pairwise { $a & $b } @mask,@ipaddr;
        my $network_binary = join('',@network);
        my @network_octets = ($network_binary =~ /(\d{8})/g);
        my @decimals = map{ _bin2dec($_) } @network_octets;
        
        my $question = "Given $ip/$prefix, network address is?";
        my $answer = join('.',@decimals);
        
        my @array = ($question,$answer);
        return @array;
    
}

1;

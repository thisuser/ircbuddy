package Ircbuddy::Dynamic::Network;

use strict;
use warnings;
use List::MoreUtils qw(pairwise);
use Ircbuddy::Core::Tools qw/ _randomip _dec2bin _bin2dec /;

sub go {
    
    my ($self,$bot,$mess,$schema) = @_;
    
    my $message = $mess->{body};
        if ($message =~ /^network\s+\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\/\d{1,2}$/) {
                my ($ip,$prefix) = ($message =~ /^network\s+(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\/(\d{1,2})$/);

                if ($prefix >= 1 && $prefix <= 32) {

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
                my $answer = join('.',@decimals);
#                $question = "Given $ip/$prefix, network address is?";
#               $start = [gettimeofday];
                $bot->reply($mess,$answer);
                }
                else {
                        $bot->reply($mess,"What the heck is that?");
                }
        }
         

}

1;
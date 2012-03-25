package Ircbuddy::Dynamic::Broadcast;

use strict;
use warnings;
use List::MoreUtils qw(pairwise);
use Ircbuddy::Core::Tools qw/ _randomip _dec2bin _bin2dec /;

sub go {
    
    my ($self,$bot,$mess,$schema) = @_;
    
    my $message = $mess->{body};
        if ($message =~ /^broadcast\s+\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\/\d{1,2}$/) {
                my ($ip,$prefix) = ($message =~ /^broadcast\s+(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\/(\d{1,2})$/);

                if ($prefix >= 1 && $prefix <= 32) {
                        # mask in binary
                        my $m_ones  = $prefix;
                        my $m_zeros = 32 - $prefix;
                        my $m_binary = 1 x $m_ones . 0 x $m_zeros;

                        # inverted mask
                        my $i_zeros  = $m_ones;
                        my $i_ones   = $m_zeros;
                        my $i_binary = 0 x $i_zeros . 1 x $i_ones;

                        # IP in binary
                        my @octets = map{_dec2bin($_) } split('\.',$ip);
                        my $join = join('',@octets);
                        my @ipaddr = split('',$join);
                        my @netmask   = split('',$m_binary);

                        my @network = pairwise { $a & $b } @netmask,@ipaddr;


                        my @inverted_mask = split('',$i_binary);
                        my @broadcast = pairwise { $a | $b } @network,@inverted_mask;

                        my $broadcast_binary = join('',@broadcast);
                        my @broadcast_octets = ($broadcast_binary =~ /(\d{8})/g);
                        my @decimals = map{ _bin2dec($_) } @broadcast_octets;
                        my $answer = join('.',@decimals);
                        $bot->reply($mess,$answer);
                }
        }

}

1;
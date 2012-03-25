package Ircbuddy::Core::Tools;

#tools


require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw(_randomip _bin2dec _dec2bin _dec2bin_nibble );

use strict;
use warnings;

sub _randomip {
        my $ip = join ".", map int rand 256, 1 .. 4;
        return $ip;
}

sub _bin2dec {
        my $binary = shift;
        my $decimal = unpack("N", pack("B32", substr("0" x 32 . $binary, -32)));
        return $decimal;
}
sub _dec2bin {
        my $decimal = shift;
        my $binary = unpack("B32", pack("N", $decimal));
        $binary =~ s/^0+(?=\d)//;   # otherwise you'll get leading zeros
        $binary = sprintf("%08d",$binary);
        return $binary;
}
sub _dec2bin_nibble {
        my $decimal = shift;
        my $binary = unpack("B32", pack("N", $decimal));
        $binary =~ s/^0+(?=\d)//;   # otherwise you'll get leading zeros
        $binary = sprintf("%04d",$binary);
        return $binary;
}

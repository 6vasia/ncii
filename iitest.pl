use strict;
use utf8;

use II::Point;

use Data::Dumper;

binmode STDOUT, ':utf8';

my $ii = II::Point->new ("http://irk38.tk/ii/ii-point.php?q=/");
my %echoes = $ii->fetch_echoes('im.100');
print Dumper (\%echoes);

for my $echo (keys %echoes) {
    my %msg = $ii->fetch_msgs(@{$echoes{$echo}}[0..9]);
    print $msg{$_}{content}, "\n===="
    	for (keys %msg);
}

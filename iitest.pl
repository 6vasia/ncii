use strict;
use utf8;

use II::Point;

use Data::Dumper;

my $ii = II::Point->new ("http://51t.ru/");
my %echoes = $ii->fetch_echoes('im.1406');
print Dumper (\%echoes);

for my $echo (keys %echoes) {
    my %msg = $ii->fetch_msgs(@{$echoes{$echo}}[0..9]);
    print Dumper ($echo, \%msg);
}

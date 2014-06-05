package II::Cache;

use strict;
use utf8;

use II::Misc qw(logger);
use Data::Dumper;

sub new($$$)
{
    my ($class, $node, $storage) = @_;
    my $self = {node => $node, storage => $storage};
    return bless $self, $class;
}

1;

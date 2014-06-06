package II::Cache::Storable;

use strict;
use utf8;

use Storable qw(store retrieve dclone);

use parent 'II::Cache';

use II::Misc qw(logger);

sub new
{
    my $class = shift;
    my $self = $class->SUPER::new(@_);

    my $filename = $self->{node};
    $filename =~ s@https?://@@;
    $filename =~ s@/.*$@@;
    
    my $filepath = $self->{storage};
    $self->{file} = $filepath.'/'.$filename.'.dump';
    $self->{opened} = 1;
    if (-e $self->{file}) {
        $self->{content} = retrieve ($self->{file});
    }
    return $self;
}

sub dump
{
    my $self = shift;
    store ($self->{content}, $self->{file}) 
        or logger( "warn", "Error storing to %s: %s", $self->{file}, $!);
}

sub echoes
{
    my ($self, $echoes) = @_;
    if (defined $echoes) {
        # store
        $self->{content}{echoes} = dclone $echoes;
    } else {
        # get
        if (defined $self->{content}{echoes}) {
            return dclone $self->{content}{echoes};
        } else {
            return {};
        }
    }
}

sub messages
{
    my ($self, $messages) = @_;
    if (defined $messages) {
        # store
        $self->{content}{messages} = dclone $messages;
    } else {
        # get
        if (defined $self->{content}{messages}) {
            return dclone $self->{content}{messages};
        } else {
            return {};
        }
    }
}

1;

package II::Cache::YAML;

use strict;
use utf8;

use Storable 'dclone';
use YAML;

use parent 'II::Cache';

use II::Misc qw(logger);
use Data::Dumper;

sub new
{
    my $class = shift;
    my $self = $class->SUPER::new(@_);

    my $filename = $self->{node};
    $filename =~ s@https?://@@;
    $filename =~ s@/.*$@@;
    
    my $filepath = $self->{storage};
    $self->{file} = $filepath.'/'.$filename.'.yaml';
    $self->{opened} = 1;
    if (-e $self->{file}) {
        $self->{content} = YAML::LoadFile ($self->{file});
    }
    return $self;
}

sub dump
{
    my $self = shift;
    YAML::DumpFile($self->{file}, $self->{content});
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

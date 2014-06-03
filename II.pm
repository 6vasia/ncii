package II;

use strict;
use utf8;

use LWP::UserAgent;
use HTTP::Request::Common;
use MIME::Base64;

use Data::Dumper;

sub new
{
    my ($class, $nodeurl, $cachedir) = @_;
    my $ua = LWP::UserAgent->new;
    $ua->env_proxy;

    my $self = {};
    $self->{nodeurl} = $nodeurl;
    $self->{ua} = $ua;
    $self->{errors} = [];
    
    return bless $self;
}

sub fetch_echoes
{
    my ($self, @echoes) = @_;
    my $ua = $self->{ua};
    my @res;
    for my $echo (@echoes) {
        my $resp = $ua->get($self->{nodeurl}.'u/e/'.$echo);
        if ($resp->is_success) {
            my @index = split (/\n/, $resp->decoded_content);
            shift @index;
            push @res, ($echo => [@index]);
        } else {
            push @{$self->{errors}}, $resp->status_line;
        }
    }
    return @res;
}

sub fetch_msgs
{
    my ($self, @msgs) = @_;
    my $ua = $self->{ua};
    my @res;
    my $resp = $ua->get($self->{nodeurl}.'u/m/'.join('/', @msgs));
    if ($resp->is_success) {
        my @rawmsgs = split (/\n/, $resp->decoded_content);

        for my $msg (@rawmsgs) {
            if ($msg =~ /(\w+):(\S+)/) {
                my $msgid = $1;
                my @msgcontent = split (/\n/, decode_base64 ($2));
                push @res, ($msgid => {
                        tags => {split "/", $msgcontent[0]},
                        echoarea => $msgcontent[1],
                        date => $msgcontent[2],
                        from => $msgcontent[3],
                        addr => $msgcontent[4],
                        to => $msgcontent[5],
                        subj => $msgcontent[6],
                        content => join ("\n", @msgcontent[8..@msgcontent])
                    });
            }
        }
    } else {
        push @{$self->{errors}}, $resp->status_line;
    }
    return @res;
}

1;

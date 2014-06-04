package II::Point;

use strict;
use utf8;

use LWP::UserAgent;
use HTTP::Request::Common;
use MIME::Base64;

use II::Misc qw(logger);
use Data::Dumper;

sub new ($$$)
{
    my ($class, $nodeurl, $authstr) = @_;
    
    logger ("debug", "new Point (%s, %s)", $nodeurl, $authstr);
    my $ua = LWP::UserAgent->new;
    $ua->env_proxy;

    my $self = {};
    $self->{nodeurl} = $nodeurl;
    $self->{authstr} = $authstr;
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
            logger ("warn", "Fetch returned %s", $resp->status_line);
        }
    }
    return @res;
}

sub fetch_msgs
{
    my ($self, @msgs) = @_;
    my $ua = $self->{ua};
    my @res;
    my $fetched = 0;
    while ($fetched < @msgs) {
        my $request = @msgs - $fetched > 100 ? 100 : @msgs - $fetched;
        my $resp = $ua->get($self->{nodeurl}.'u/m/'.join('/', @msgs[$fetched..$fetched+$request-1]));
        $fetched += $request;
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
            logger ("warn", "Fetch returned %s", $resp->status_line);
            push @{$self->{errors}}, $resp->status_line;
        }
    }
    return @res;
}

sub post
{
    my ($self, @msgs) = @_;
    my $ua = $self->{ua};
    for my $msg (@msgs) {
        my $rawmsg = encode_base64(join ("\n", 
            $msg->{echoarea},
            $msg->{to},
            $msg->{subj},
            '', 
            $msg->{content}
        ));
        my $resp = $ua->request(POST ($self->{nodeurl}.'u/point', [tmsg => $rawmsg, pauth => $self->{authstr}]));
        unless ($resp->is_success) {
            push @{$self->{errors}}, $resp->status_line;
        }
        unless ($resp->decoded_content =~ /msg ok/) {
            push @{$self->{errors}}, $resp->decoded_content;
        }
    }
    return;
}

sub pop_errors
{
    my $self = shift;
    my @ret = @{$self->{errors}};
    $self->{errors} = [];
    return @ret;
}


1;

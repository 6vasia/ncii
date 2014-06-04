package II::Misc;

use strict;
use utf8;

use parent qw(Exporter);
use Env qw(HOME);

our @EXPORT_OK = qw(logger logger_facility);

my $facility;
my $is_daemon = 0;

sub logfile
{
    return $is_daemon ? "/var/log/$facility" : defined $HOME ? $HOME . "/.config/$facility/log" : "$facility.log";
}

sub logger_facility($)
{
    $facility = shift;
    my $daemon = shift;
    $is_daemon = $daemon if defined $daemon;
    print "logfile is ", logfile(), "\n";
}

sub logger
{
    my $priority = shift;
    my $format = shift;
    
    return unless $facility;
    
    my $logfile = logfile;
    if (open my $log, ">>", $logfile) {
        print $log $priority, ": ";
        printf $log $format, @_;
        print $log "\n";
        close $log;
    } 
}
1;

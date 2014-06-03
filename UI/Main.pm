package UI::Main;

use strict;
use utf8;

use II;
use Curses::UI;

sub new
{
    my $self = {};
    $self->{echolist_w} = 16;
    my $cui = new Curses::UI ( 
        -clear_on_exit => 1, 
        -mouse_support => 1,
        -color_support => 1,
        -debug => 0,
        -utf8 => 1,
    );
    my $mainwin = $cui->add (
        'mainwin', 'Window',
        -border => 0,
    );
    my $echowin = $mainwin->add (
        'echowin', 'Window',
        -border => 1,
        -width => $self->{echolist_w}
    );
    $echowin->add (
        'echolist', 'Listbox',
        -border => 0,
        -values => ['im.1406', 'ii.dev.14'],
    );
    my $msgswin = $mainwin->add (
        'msgwin', 'Window', 
        -border => 1,
        -x => $self->{echolist_w}
    );
    
    $cui->set_binding( sub {$cui->mainloopExit;} , "\cQ");
    $cui->set_binding( sub {
            $echowin->{-width} += 1;
            $echowin->layout;
            $msgwin->{-x} += 1;
            $msgwin->layout;
            $mainwin->draw;
        } , "\c]");
    $cui->set_binding( sub {
            $echowin->{-width} -= 1;
            $echowin->layout;
            $msgwin->{-x} -= 1;
            $msgwin->layout;
            $mainwin->draw;
        } , "\c[");
    
    $self->{cui} = $cui;
    
    return bless $self;
}

sub loop
{
    my $self = shift;
    $self->{cui}->mainloop;
}

1;

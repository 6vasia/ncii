package UI::Main;

use strict;
use utf8;

use Curses;
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
    my $echolist = $echowin->add (
        'echolist', 'Listbox',
        -border => 0,
        -values => ['im.1406', 'ii.dev.14', 'ii.test.14'],
    );
    my $msgwin = $mainwin->add (
        'msgwin', 'Window', 
        -border => 0,
        -x => $self->{echolist_w},
    );
    my $msglist = $msgwin->add (
        'msglist', 'Listbox',
        -border => 1,
        -height => $msgwin->{-sh}/2,
        -vscrollbar => 'right',
        -values => [(0..100)]
    );
    my $preview = $msgwin->add (
        'prewiew', 'TextViewer', 
        -border => 1,
        -y => int($msgwin->{-sh}/2),
#        -height => $msgwin->{-sh} - int($msgwin->{-sh}/2)
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
    $cui->set_binding(sub {$echolist->option_next; $echolist->option_select; $echolist->draw} ,KEY_NPAGE());
    $cui->set_binding(sub {$echolist->option_prev; $echolist->option_select; $echolist->draw} ,KEY_PPAGE());
    $echolist->onChange(sub {$msglist->title($echolist->get_active_value()); $msglist->draw;});
    
    $echolist->set_selection(0);
    $msgwin->focus;
    $self->{cui} = $cui;
    
    return bless $self;
}

sub loop
{
    my $self = shift;
    $self->{cui}->mainloop;
}

1;

use strict;
use vars qw($VERSION %IRSSI);

use Irssi;
$VERSION = '20071209';
%IRSSI = (
    authors     => '',
    contact     => '',
    name        => 'rewrite',
    description => 'rewrite my common mistakes',
    license => '',
);

sub send_text {

    #"send text", char *line, SERVER_REC, WI_ITEM_REC
    my ( $data, $server, $witem ) = @_;
    if ( $witem
        && ( $witem->{type} eq "CHANNEL" )
        && ( $data =~ /(^ls |^ls$)/ ) )
    {
        $witem->command("names $witem->{name}");
        Irssi::signal_stop();
    }
    if ( $witem && ( $witem->{type} eq "QUERY" ) && ( $data =~ /(^ls |^ls$)/ ) )
    {
        $witem->command("whois $witem->{name}");
        Irssi::signal_stop();
    }
    if ( $witem
        && ( $data =~ /(^\\quit$)/ ) )
    {
        $witem->command("quit");
        Irssi::signal_stop();
    }
}

Irssi::signal_add 'send text' => 'send_text'

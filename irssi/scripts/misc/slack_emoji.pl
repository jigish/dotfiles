# slack_emoji.pl
#   This script converts slack emoji to smileys.

use strict;
use warnings;
use vars qw($VERSION %IRSSI);

use Irssi;
$VERSION = '0.03';
%IRSSI = (
    authors=> 'Lars Djerf',
    contact=> 'lars.djerf@gmail.com',
    name=> 'slack_emoji',
    description=> 'This script converts Slack emoji to smileys.',
    license=> 'GPLv3',
    );

my %emoji = ('smile' => '😄 ',
	     'simple_smile' => '😊 ',
	     'smiley' => '😃 ',
	     'grin' => '😀 ',
	     'wink' => '😉 ',
	     'smirk' => '😏 ',
	     'blush' => '😳 ',
	     'joy' => '😂 ',
	     'stuck_out_tongue' => '😛 ',
	     'stuck_out_tongue_winking_eye' => '😜 ',
	     'stuck_out_tongue_closed_eyes' => '😝 ',
	     'disappointed' => '😞 ',
	     'astonished' => '😲 ',
	     'open_mouth' => '😮 ',
	     'heart' => '❤ ',
	     'broken_heart' => '💔 ',
	     'thumb' => '👍 ',
	     'thumbsup' => '👍 ',
	     'coffee' => '☕ ',
	     'confused' => '😕 ');


sub event_message ($$$) {
    my ($server, $msg, @rest) = @_;
    my @matches = ($msg =~ /\:(\w+)\:/g);
    foreach (@matches) {
	if ($emoji{$_}) {
	    my $smiley = $emoji{$_};
	    $msg =~ s/\:$_\:/$smiley/;
	}
    }
    Irssi::signal_continue($server, $msg, @rest);
}

Irssi::signal_add_first('message public', 'event_message');
Irssi::signal_add_first('message private', 'event_message');

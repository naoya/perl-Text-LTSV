use strict;
use Test::More tests => 3;

use Text::LTSV;

my $hash = Text::LTSV->parse_line("hoge:foo\tbar:baz\ttime:20:30:58\n");
is $hash->{hoge}, 'foo';
is $hash->{bar},  'baz';
is $hash->{time}, '20:30:58';

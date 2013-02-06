use strict;
use Test::More tests => 2;

use Text::LTSV;

my $hash = Text::LTSV->parse_line("hoge:foo\tbar:baz\n");
is $hash->{hoge}, 'foo';
is $hash->{bar},  'baz';

use strict;
use Test::More tests => 3;

use utf8;
use Text::LTSV;

my $ltsv = Text::LTSV->new(
    hoge => 'foo',
    bar  => 'baz',
);

my $line = $ltsv->to_s;

is $line, "hoge:foo\tbar:baz";

my $p = Text::LTSV->new;
is($p->parse_line($line)->{hoge}, 'foo');
is($p->parse_line($line)->{bar}, 'baz');

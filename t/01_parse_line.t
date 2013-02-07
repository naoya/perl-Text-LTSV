use strict;
use Test::More tests => 6;

use Text::LTSV;

{
    my $p = Text::LTSV->new;
    my $hash = $p->parse_line("hoge:foo\tbar:baz\ttime:20:30:58\n");
    is $hash->{hoge}, 'foo';
    is $hash->{bar},  'baz';
    is $hash->{time}, '20:30:58';
}


{
    my $p = Text::LTSV->new;
    $p->want_fields('hoge', 'time');

    my $hash = $p->parse_line("hoge:foo\tbar:baz\ttime:20:30:58\n");
    is $hash->{hoge}, 'foo';
    ok not exists $hash->{bar};
    is $hash->{time}, '20:30:58';
}

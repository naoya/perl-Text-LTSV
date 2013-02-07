use strict;
use Test::More tests => 13;

use utf8;
use Text::LTSV;
use Errno ();

my $p = Text::LTSV->new;

{
    my $data = $p->parse_file_utf8('./t/test.ltsv');
    is $data->[0]->{hoge}, 'foo';
    is $data->[0]->{bar}, 'baz';
    is $data->[1]->{perl}, '5.17.8';
    is $data->[2]->{tennpura}, '天ぷら';

    eval { $p->parse_file('./t/not_found') };
    ok $! == Errno::ENOENT;
}

{
    my $it = $p->parse_file_iter_utf8('./t/test.ltsv');

    ok $it->has_next;
    my $hash = $it->next;
    is $hash->{hoge}, 'foo';

    ok $it->has_next;
    $hash = $it->next;
    is $hash->{ruby}, '2.0';

    ok $it->has_next;
    $hash = $it->next;
    is $hash->{tennpura}, '天ぷら';

    ok not $it->has_next;
    ok $it->end;
}

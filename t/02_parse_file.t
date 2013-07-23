use strict;
use Test::More tests => 23;

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
    my $data1 = $p->parse_file_utf8('./t/test.ltsv');
    my $data2 = Text::LTSV->parse_file_utf8('./t/test.ltsv');
    is_deeply $data2->[0], $data1->[0];
    is_deeply $data2->[1], $data1->[1];
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

{
    my $it1 = $p->parse_file_iter_utf8('./t/test.ltsv');
    my $it2 = Text::LTSV->parse_file_iter_utf8('./t/test.ltsv');

    ok $it1->has_next && $it2->has_next;
    my $hash1 = $it1->next;
    my $hash2 = $it2->next;
    is $hash2->{hoge}, $hash1->{hoge};

    ok $it1->has_next && $it2->has_next;
    $hash1 = $it1->next;
    $hash2 = $it2->next;
    is $hash2->{ruby}, $hash1->{ruby};

    ok $it1->has_next && $it2->has_next;
    $hash1 = $it1->next;
    $hash2 = $it2->next;
    is $hash2->{tennpura}, $hash1->{tennpura};

    ok (not $it1->has_next and not $it2->has_next);
    ok $it1->end && $it2->end;
}

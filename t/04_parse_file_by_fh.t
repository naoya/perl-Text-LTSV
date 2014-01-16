use strict;
use warnings;
use utf8;
use Text::LTSV;

use Test::More;

my $p = Text::LTSV->new;

{
    open my $fh, "<", './t/test.ltsv';
    my $data = $p->parse_file_utf8($fh);

    is $data->[0]->{hoge}, 'foo';
    is $data->[0]->{bar}, 'baz';
    is $data->[1]->{perl}, '5.17.8';
    is $data->[2]->{tennpura}, '天ぷら';
};

{
    open my $fh, "<", './t/test.ltsv';

    my $it = $p->parse_file_iter_utf8($fh);

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
};

{
    open my $fh, "<:encoding(UTF-8)", './t/test.ltsv';
    my $data = $p->parse_file_utf8($fh);

    is $data->[2]->{tennpura}, '天ぷら';
}

done_testing;

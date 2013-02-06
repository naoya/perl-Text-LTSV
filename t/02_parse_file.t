use strict;
use Test::More tests => 5;

use utf8;
use Text::LTSV;

my $data = Text::LTSV->parse_file_utf8('./t/test.ltsv');
is $data->[0]->{hoge}, 'foo';
is $data->[0]->{bar}, 'baz';
is $data->[1]->{perl}, '5.17.8';
is $data->[2]->{tennpura}, '天ぷら';

eval { Text::LTSV->parse_file('./t/not_found') };
like $@, qr/No such file or directory/;

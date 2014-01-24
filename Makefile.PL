use strict;
use warnings;
use inc::Module::Install;

name 'Text-LTSV';
all_from 'lib/Text/LTSV.pm';
# readme_from 'lib/Text/LTSV.pm';

tests 't/*.t';
author_tests 'xt';

install_script 'bin/ltsview';

auto_set_repository;
auto_provides;
cpanfile;
WriteAll;

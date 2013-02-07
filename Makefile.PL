use inc::Module::Install;
name 'Text-LTSV';
all_from 'lib/Text/LTSV.pm';

requires 'Tie::IxHash';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;

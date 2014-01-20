requires 'Getopt::Long';
requires 'Tie::IxHash';
requires 'Project::Libs';
requires 'UNIVERSAL::require';
requires 'YAML::Tiny::Color';
requires 'Scalar::Util';

on 'test' => sub {
    requires 'Test::More';
};

on configure => sub {
    requires 'inc::Module::Install';
};

on develop => sub {
    requires 'Test::Perl::Critic';
};

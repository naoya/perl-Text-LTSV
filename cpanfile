requires 'Tie::IxHash';
requires 'Project::Libs';
requires 'UNIVERSAL::require';
requires 'YAML::Tiny::Color';

on 'test' => sub {
    requires 'Test::More';
};

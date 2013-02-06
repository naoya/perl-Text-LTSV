package Text::LTSV;
use strict;
use warnings;

our $VERSION = '0.01';

use IO::File;
use Carp qw/croak/;

sub new {
    my ($class, @kv) = @_;
    bless \@kv, $class;
}

sub parse_line {
    my ($class, $line) = @_;
    chomp $line;
    return +{ map { split ':' } split "\t", $line }
}

sub parse_file {
    my ($class, $path, $opt) = @_;
    $opt ||= {};
    my $fh = IO::File->new($path, $opt->{utf8} ? '<:utf8' : 'r') or croak $!;
    my @out;
    while (my $line = $fh->getline) {
        push @out, $class->parse_line($line);
    }
    $fh->close;
    return \@out;
}

sub parse_file_utf8 {
    my ($class, $path) = @_;
    return $class->parse_file($path, { utf8 => 1 });
}

sub to_s {
    my $self = shift;
    my $n = @$self;
    my @out;
    for (my $i = 0; $i < $n; $i += 2) {
        push @out, join ':', $self->[$i], $self->[$i+1];
    }
    return join "\t", @out;
}


1;
__END__

=head1 NAME

Text::LTSV - Labeled Tab Separeted Value manipulator

=head1 SYNOPSIS

  use Text::LTSV;
  my $hash = Text::LTSV->parse_line("hoge:foo\tbar:baz\n");
  is $hash->{hoge}, 'foo';
  is $hash->{bar},  'baz';

  my $data = Text::LTSV->parse_file('./t/test.ltsv'); # or parse_file_utf8
  is $data->[0]->{hoge}, 'foo';
  is $data->[0]->{bar}, 'baz';

  my $ltsv = Text::LTSV->new(
    hoge => 'foo',
    bar  => 'baz',
  );
  is $ltsv->to_s, "hoge:foo\tbar:baz";

=head1 DESCRIPTION

Labeled Tab Separated Value L<http://stanaka.hatenablog.com/entry/2013/02/05/214833> is a Key-Value pair + line-based text format for log files, especially HTTP access_log.

This module provides a simple way to process LSTV-based string and files, which converts Key-Value pair(s) of LSTV to Perl's hash reference(s).

=head1 AUTHOR

Naoya Ito E<lt>i.naoya@gmail.comE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

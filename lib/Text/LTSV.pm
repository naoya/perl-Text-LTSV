package Text::LTSV;
use strict;
use warnings;

our $VERSION = '0.05';

use IO::File;
use Carp qw/croak/;
use Text::LTSV::Iterator;

sub new {
    my ($self, @kv) = @_;
    # bless \@kv, $self;
    return bless {
        _kv      => \@kv,
        _wants   => [],
        _ignores => [],
    }, $self;
}

sub ignore_fields {
    my ($self, @keys) = @_;
    @keys ? $self->{_ignores} = \@keys :  return $self->{_ignores};
}

sub want_fields {
    my ($self, @keys) = @_;
    @keys ? $self->{_wants} = \@keys :  return $self->{_wants};
}

sub ordered {
    my $self = shift;
    @_ ? $self->{_ordered} = shift : return $self->{_ordered};
}

sub has_wants {
    @{shift->want_fields} ? 1 : 0;
}

sub has_ignores {
    @{shift->ignore_fields} ? 1 : 0;
}

sub parse_line {
    my ($self, $line) = @_;
    chomp $line;
    my $has_wants   = $self->has_wants;
    my $has_ignores = $self->has_ignores;

    my %wants;
    if ($has_wants) {
        %wants = map { $_ => 1  } @{$self->want_fields};
    }

    my %ignores;
    if ($has_ignores) {
        %ignores = map { $_ => 1  } @{$self->ignore_fields};
    }

    my %kv;
    if ($self->ordered) {
        require Tie::IxHash;
        tie %kv, 'Tie::IxHash';
    }
    for (map { [ split ':', $_, 2 ] } split "\t", $line) {
        next if $has_ignores and $ignores{$_->[0]};
        next if $has_wants and not $wants{$_->[0]};
        $kv{$_->[0]} = $_->[1];
    }
    return \%kv;
}

sub parse_file {
    my ($self, $path, $opt) = @_;
    $opt ||= {};
    my $fh = IO::File->new($path, $opt->{utf8} ? '<:utf8' : 'r') or croak $!;
    my @out;
    while (my $line = $fh->getline) {
        push @out, $self->parse_line($line);
    }
    $fh->close;
    return \@out;
}

sub parse_file_utf8 {
    my ($self, $path) = @_;
    return $self->parse_file($path, { utf8 => 1 });
}

sub parse_file_iter {
    my ($self, $path, $opt) = @_;
    $opt ||= {};
    my $fh = IO::File->new($path, $opt->{utf8} ? '<:utf8' : 'r') or croak $!;
    return Text::LTSV::Iterator->new($self, $fh);
}

sub parse_file_iter_utf8 {
    my ($self, $path) = @_;
    return $self->parse_file_iter($path, { utf8 => 1 });
}

sub to_s {
    my $self = shift;
    my $n = @{$self->{_kv}};
    my @out;

    for (my $i = 0; $i < $n; $i += 2) {
        push @out, join ':', $self->{_kv}->[$i], $self->{_kv}->[$i+1];
    }
    return join "\t", @out;
}


1;
__END__

=head1 NAME

Text::LTSV - Labeled Tab Separated Value manipulator

=head1 SYNOPSIS

  use Text::LTSV;
  my $p = Text::LTSV->new;
  my $hash = $p->parse_line("hoge:foo\tbar:baz\n");
  is $hash->{hoge}, 'foo';
  is $hash->{bar},  'baz';

  my $data = $p->parse_file('./t/test.ltsv'); # or parse_file_utf8
  is $data->[0]->{hoge}, 'foo';
  is $data->[0]->{bar}, 'baz';

  # Iterator interface
  my $it = $p->parse_file_iter('./t/test.ltsv'); # or parse_file_iter_utf8
  while ($it->has_next) {
      my $hash = $it->next;
      ...
  }
  $it->end;

  # Only want certain fields?
  my $p = Text::LTSV->new;
  $p->want_fields('hoge');
  $p->parse_line("hoge:foo\tbar:baz\n");

  # Vise versa
  my $p = Text::LTSV->new;
  $p->ignore_fields('hoge');
  $p->parse_line("hoge:foo\tbar:baz\n");

  my $ltsv = Text::LTSV->new(
    hoge => 'foo',
    bar  => 'baz',
  );
  is $ltsv->to_s, "hoge:foo\tbar:baz";

=head1 DESCRIPTION

Labeled Tab-separated Values (LTSV) format is a variant of
Tab-separated Values (TSV). Each record in a LTSV file is represented
as a single line. Each field is separated by TAB and has a label and a
value. The label and the value have been separated by ':'.

cf: L<http://ltsv.org/>

This format is useful for log files, especially HTTP access_log.

This module provides a simple way to process LTSV-based string and
files, which converts Key-Value pair(s) of LTSV to Perl's hash
reference(s).

=head1 AUTHOR

Naoya Ito E<lt>i.naoya@gmail.comE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

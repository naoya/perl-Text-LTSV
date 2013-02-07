package Text::LTSV;
use strict;
use warnings;

our $VERSION = '0.01';

use IO::File;
use Carp qw/croak/;

sub new {
    my ($self, @kv) = @_;
    # bless \@kv, $self;
    return bless {
        _kv     => \@kv,
        _wants  => [],
    }, $self;
}

sub want_fields {
    my ($self, @keys) = @_;
    if (@keys) {
        $self->{_wants} = \@keys;
    }
    return @{$self->{_wants}};
}

sub has_wants {
    @{shift->{_wants}} ? 1 : 0;
}

sub parse_line {
    my ($self, $line) = @_;
    chomp $line;
    my $has_wants = $self->has_wants;

    my %wants;
    if ($has_wants) {
        %wants = map { $_ => 1  } @{$self->{_wants}};
    }

    my $kv = {};
    for (map { [ split ':', $_, 2 ] } split "\t", $line) {
        if ($has_wants and not $wants{$_->[0]}) {
            next;
        }
        $kv->{$_->[0]} = $_->[1];
    }
    return $kv;
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

Text::LTSV - Labeled Tab Separeted Value manipulator

=head1 SYNOPSIS

  use Text::LTSV;
  my $p = Text::LTSV->new;
  my $hash = $p->parse_line("hoge:foo\tbar:baz\n");
  is $hash->{hoge}, 'foo';
  is $hash->{bar},  'baz';

  my $data = $p->parse_file('./t/test.ltsv'); # or parse_file_utf8
  is $data->[0]->{hoge}, 'foo';
  is $data->[0]->{bar}, 'baz';

  # Only want certain fields?
  my $p = Text::LTSV->new;
  $p->want_fields('hoge');
  $p->parse_line("hoge:foo\tbar:baz\n");

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

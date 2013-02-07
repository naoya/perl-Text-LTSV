package Text::LTSV::Iterator;
use strict;
use warnings;

sub new {
    my ($class, $parser, $handle) = @_;
    return bless {
        _parser => $parser,
        _handle => $handle,
    }, $class;
}

sub has_next {
    my $self = shift;
    $self->{_handle}->eof ? 0 : 1;
}

sub next {
    my $self = shift;
    return $self->{_parser}->parse_line( $self->{_handle}->getline );
}

sub end {
    shift->{_handle}->close;
}

1;

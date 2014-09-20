use strict;
use warnings;
package Math::Shape::Range;
$Math::Shape::Range::VERSION = '0.06';
use 5.008;
use Carp;
use Math::Shape::Utils;

# ABSTRACT: a range object which has min and max values


sub new
{
    croak 'incorrect number of args' unless @_ == 3;
    my ($class, $min, $max) = @_;
    bless { min => $min, max => $max }, $class;
}


sub sort
{
    my $self = shift;

    if ($self->{min} > $self->{max})
    {
        my $new_max = $self->{min};
        $self->{min} = $self->{max};
        $self->{max} = $new_max;
    }
    return $self;
}


sub is_overlapping
{
    croak 'Must provide another Math::Shape::Range object as argument' unless $_[1]->isa('Math::Shape::Range');
    overlap($_[0]->{min}, $_[0]->{max}, $_[1]->{min}, $_[1]->{max});
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Math::Shape::Range - a range object which has min and max values

=head1 VERSION

version 0.06

=head1 METHODS

=head2 new

Constructor, requires 2 values: minimum and maximum floating point numbers.

    my $range = Math::Shape::Range->new(3.5, 4);

=head2 sort

Sorts the range so that the min is lower than the max attributes.

    $range->sort;

=head2 is_overlapping

Boolean method which returns 1 if the range object overlaps with another range, or 0 if not. Requires another range object as an argument.

    my $range1 = Math::Shape::Range->new(1, 10);
    my $range2 = Math::Shape::Range->new(11, 20);
    my $range3 = Math::Shape::Range->new(15, 25);
    $range1->is_overlapping($range2); # 0
    $range2->is_overlapping($range3); # 1

=head1 AUTHOR

David Farrell <sillymoos@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by David Farrell.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

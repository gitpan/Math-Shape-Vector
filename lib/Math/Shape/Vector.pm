use strict;
use warnings;
package Math::Shape::Vector;
$Math::Shape::Vector::VERSION = '0.01';
use 5.008;
use Carp;

# ABSTRACT: A 2d vector object in cartesian space


sub new {
    croak 'incorrect number of arguments' unless @_ == 3;
    return bless { x => $_[1],
                   y => $_[2] }, $_[0];
}


sub add_vector {
    croak 'must pass a vector object' unless $_[1]->isa('Math::Shape::Vector');
    my ($self, $v2) = @_;
    $self->{x} += $v2->{x};
    $self->{y} += $v2->{y};
    1;
}


sub subtract_vector {
    croak 'must pass a vector object' unless $_[1]->isa('Math::Shape::Vector');
    my ($self, $v2) = @_;
    $self->{x} -= $v2->{x};
    $self->{y} -= $v2->{y};
    1;
}


sub negate {
    my $self = shift;
    $self->{x} = - $self->{x};
    $self->{y} = - $self->{y};
    1;
}


sub is_equal {
    croak 'must pass a vector object' unless $_[1]->isa('Math::Shape::Vector');
    my ($self, $v2) = @_;
    $self->{x} == $v2->{x} && $self->{y} == $v2->{y}
        ? 1 : 0;
}


sub multiply {
    croak 'incorrect number of args' unless @_ == 2;
    my ($self, $multiplier) = @_;
    $self->{x} = $self->{x} * $multiplier;
    $self->{y} = $self->{y} * $multiplier;
    1;
}


sub divide {
    croak 'incorrect number of args' unless @_ == 2;
    my ($self, $divisor) = @_;
    $self->{x} = $self->{x} / $divisor;
    $self->{y} = $self->{y} / $divisor;
    1;
}


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Math::Shape::Vector - A 2d vector object in cartesian space

=head1 VERSION

version 0.01

=head1 METHODS

=head2 new

Create a new vector. Requires two numerical arguments for the origin and magnitude.

    my $vector = Math::Shape::Vector->new(3, 5);

=head2 add_vector

Adds a vector to the vector object, updating its x & y values.

    $vector->add_vector($vector_2);

=head2 subtract_vector

Subtracts a vector from the vector object, updating its x & y values.

    $vector->subtract_vector($vector_2);

=head2 negate

Negates the vector's values e.g. (1,3) becomes (-1, -3).

    $vector->negate();

=head2 is_equal

Compares a vector to the vector object, returning 1 if they are the same or 0 if they are different.

    $vector->is_equal($vector_2);

=head2 multiply

Multiplies the vector's x and y values by a number.

    $vector->multiply(3);

=head2 divide

Divides the vector's x and y values by a number.

    $vector->divide(2);

=head1 RESPOSITORY

L<https://github.com/sillymoose/Math-Shape-Vector.git>

=head1 THANKS

The source code for this object was inspired by the code in Thomas Schwarzl's 2d collision detection book L<http://www.collisiondetection2d.net>.

=head1 AUTHOR

David Farrell <sillymoos@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by David Farrell.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

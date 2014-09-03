use strict;
use warnings;
package Math::Shape::Vector;
$Math::Shape::Vector::VERSION = '0.04';
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
    $self;
}


sub subtract_vector {
    croak 'must pass a vector object' unless $_[1]->isa('Math::Shape::Vector');
    my ($self, $v2) = @_;
    $self->{x} -= $v2->{x};
    $self->{y} -= $v2->{y};
    $self;
}


sub negate {
    my $self = shift;
    $self->{x} = - $self->{x};
    $self->{y} = - $self->{y};
    $self;
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
    $self;
}


sub divide {
    croak 'incorrect number of args' unless @_ == 2;
    my ($self, $divisor) = @_;
    # avoid division by zero
    $self->{x} = $divisor ? $self->{x} / $divisor : 0;
    $self->{y} = $divisor ? $self->{y} / $divisor : 0;
    $self;
}


sub rotate {
    croak 'incorrect number of args' unless @_ == 2;
    my ($self, $radians) = @_;

    $self->{x} = $self->{x} * cos($radians) - $self->{y} * sin($radians);
    $self->{y} = $self->{x} * sin($radians) + $self->{y} * cos($radians);
    $self;
}


sub get_dot_product {
    croak 'must pass a vector object' unless $_[1]->isa('Math::Shape::Vector');
    my ($self, $v2) = @_;
    $self->{x} * $v2->{x} + $self->{y} * $v2->{y};
}


sub get_length {
    my $self = shift;
    # avoid division by zero for null vectors
    return 0 unless $self->{x} && $self->{y};
    sqrt $self->{x} ** 2 + $self->{y} ** 2;
}


sub convert_to_unit_vector {
    my $self = shift;

    my $length = $self->get_length;
    $length > 0 ? $self->divide($length) : 1;
    $self;
}


sub project {
    croak 'must pass a vector object' unless $_[1]->isa('Math::Shape::Vector');
    my ($self, $v2) = @_;

    my $d = $v2->get_dot_product($v2);
    if ($d > 0) {
        $v2->multiply( $self->get_dot_product($v2) / $d );
    }
    else {
        $self = $v2;
    }
    $self;
}



1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Math::Shape::Vector - A 2d vector object in cartesian space

=head1 VERSION

version 0.04

=head1 SYNOPSIS

    use Math::Shape::Vector;

    my $v1 = Math::Shape::Vector->new(3, 5);
    my $v2 = Math::Shape::Vector->new(1, 17);

    $v1->add_vector($v2);
    $v1->negate;
    $v1->multiply(5);
    $v1->is_equal($v2);

=for HTML <a href="https://travis-ci.org/sillymoose/Math-Shape-Vector"><img src="https://travis-ci.org/sillymoose/Math-Shape-Vector.svg?branch=master"></a> <a href='https://coveralls.io/r/sillymoose/Math-Shape-Vector'><img src='https://coveralls.io/repos/sillymoose/Math-Shape-Vector/badge.png' alt='Coverage Status' /></a>

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

=head2 rotate

Rotates the vector in radians.

    use Math::Trig ':pi';

    $vector->rotate(pi);

=head2 get_dot_product

Returns the dot product. Requires another Math::Shape::Vector object as an argument.

=head2 get_length

Returns the vector length.

    $vector->get_length;

=head2 convert_to_unit_vector

Converts the vector to have a length of 1.

    $vector->convert_to_unit_vector;

=head2 project

Maps the vector to another vector. Requires a Math::Shape::Vector object as an argument.

    $vector->project($vector_2);

=head1 REPOSITORY

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

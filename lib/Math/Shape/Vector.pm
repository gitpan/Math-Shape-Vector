use strict;
use warnings;
package Math::Shape::Vector;
$Math::Shape::Vector::VERSION = '0.09';
use 5.008;
use Carp;
use Math::Shape::Utils;
use Math::Trig;

# ABSTRACT: A 2d vector library in cartesian space


sub new {
    croak 'incorrect number of arguments' unless @_ == 3;
    return bless { x => $_[1],
                   y => $_[2] }, $_[0];
}


sub add_vector {
    croak 'must pass a vector object' unless $_[1]->isa('Math::Shape::Vector');
    my ($self, $v2) = @_;

    Math::Shape::Vector->new(
        $self->{x} + $v2->{x},
        $self->{y} + $v2->{y},
    );
}


sub subtract_vector {
    croak 'must pass a vector object' unless $_[1]->isa('Math::Shape::Vector');
    my ($self, $v2) = @_;

    Math::Shape::Vector->new(
        $self->{x} - $v2->{x},
        $self->{y} - $v2->{y},
    );
}


sub negate {
    my $self = shift;

    Math::Shape::Vector->new(
        - $self->{x},
        - $self->{y},
    );
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

    Math::Shape::Vector->new(
        $self->{x} * $multiplier,
        $self->{y} * $multiplier,
    );
}


sub divide {
    croak 'incorrect number of args' unless @_ == 2;
    my ($self, $divisor) = @_;

    # avoid division by zero
    Math::Shape::Vector->new(
        ($divisor ? $self->{x} / $divisor : 0),
        ($divisor ? $self->{y} / $divisor : 0),
    );
}


sub rotate {
    croak 'incorrect number of args' unless @_ == 2;
    my ($self, $radians) = @_;

    Math::Shape::Vector->new(
        $self->{x} * cos($radians) - $self->{y} * sin($radians),
        $self->{x} * sin($radians) + $self->{y} * cos($radians),
    );
}


sub rotate_90
{
    my $self = shift;

    Math::Shape::Vector->new(
        - $self->{y},
        $self->{x},
    );
}


sub dot_product {
    croak 'must pass a vector object' unless $_[1]->isa('Math::Shape::Vector');
    my ($self, $v2) = @_;
    $self->{x} * $v2->{x} + $self->{y} * $v2->{y};
}


sub length {
    my $self = shift;
    # avoid division by zero for null vectors
    my $sum_of_squares = ( $self->{x} || 0 ) ** 2
                         + ( $self->{y} || 0 ) ** 2;
    return 0 unless $sum_of_squares;
    sqrt $sum_of_squares;
}


sub convert_to_unit_vector {
    my $self = shift;

    my $length = $self->length;
    $length = 1 unless $length > 0;
    $self->divide($length)
}


sub project {
    croak 'must pass a vector object' unless $_[1]->isa('Math::Shape::Vector');
    my ($self, $v2) = @_;

    my $d = $v2->dot_product($v2);

    if ($d > 0) {
        $v2->multiply( $self->dot_product($v2) / $d );
    }
    else {
        $v2;
    }
}


sub is_parallel
{
    croak 'must pass a vector object' unless $_[1]->isa('Math::Shape::Vector');
    my ($self, $v2) = @_;
    my $vector_na = $self->rotate_90;
    equal_floats(0, $vector_na->dot_product($v2));
}


sub enclosed_angle
{
    croak 'must pass a vector object' unless $_[1]->isa('Math::Shape::Vector');
    my ($self, $v2) = @_;

    my $ua = $self;
    $ua->unit_vector;

    my $ub = $v2;
    $ub->unit_vector;

    acos( $ua->dot_product($ub) );
}



sub collides
{
    my ($self, $other_obj) = @_;

    if ($other_obj->isa('Math::Shape::Vector'))
    {
        $self->{x} == $other_obj->{x} && $self->{y} == $other_obj->{y} ? 1 : 0;
    }
    elsif ($other_obj->isa('Math::Shape::Circle'))
    {
        $other_obj->collides($self);
    }
    else
    {
        croak 'collides must be called with a Math::Shape::Vector library object';
    }
}


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Math::Shape::Vector - A 2d vector library in cartesian space

=head1 VERSION

version 0.09

=head1 SYNOPSIS

    use Math::Shape::Vector;

    my $v1 = Math::Shape::Vector->new(3, 5);
    my $v2 = Math::Shape::Vector->new(1, 17);

    $v1->add_vector($v2);
    $v1->negate;
    $v1->multiply(5);
    $v1->is_equal($v2);

=head1 DESCRIPTION

This module contains 2d vector-based objects intended as base classes for 2d games programming. Most of the objects have collision detection (among other methods). The objects available are:

=over

=item *

L<Math::Shape::Vector> - a 2d vector (this module)

=item *

L<Math::Shape::Line> - an infinite 2d line

=item *

L<Math::Shape::LineSegment> - a finite 2d line (with a start and end)

=item *

L<Math::Shape::Range> - a number range (e.g 1 through 20)

=item *

L<Math::Shape::Circle> - a 2d Circle

=item *

L<Math::Shape::Rectangle> - a 2d axis-oriented rectangle

=item *

L<Math::Shape::OrientedRectangle> - a 2d oriented rectangle

=back

=for HTML <a href="https://travis-ci.org/sillymoose/Math-Shape-Vector"><img src="https://travis-ci.org/sillymoose/Math-Shape-Vector.svg?branch=master"></a> <a href='https://coveralls.io/r/sillymoose/Math-Shape-Vector'><img src='https://coveralls.io/repos/sillymoose/Math-Shape-Vector/badge.png' alt='Coverage Status' /></a>

=head1 METHODS

=head2 new

Create a new vector. Requires two numerical arguments for the origin and magnitude.

    my $vector = Math::Shape::Vector->new(3, 5);

=head2 add_vector

Adds a vector to the vector object, returning a new vector object with the resulting x & y values.

    my $new_vector = $vector->add_vector($vector_2);

=head2 subtract_vector

Subtracts a vector from the vector object, returning a new vector object with the resulting x & y values.

    my $new_vector = $vector->subtract_vector($vector_2);

=head2 negate

Returns a new vector with negated values values e.g. (1,3) becomes (-1, -3).

    my $new_vector = $vector->negate();

=head2 is_equal

Compares a vector to the vector object, returning 1 if they are the same or 0 if they are different.

    $vector->is_equal($vector_2);

=head2 multiply

Returns a new vector object with the x and y values multiplied by a number.

    my $new_vector = $vector->multiply(3);

=head2 divide

Returns a new vector object with the x and y values divided by a number.

    my $new_vector = $vector->divide(2);

=head2 rotate

Returns a new vector with the x and y values rotated in radians.

    use Math::Trig ':pi';

    my $new_vector = $vector->rotate(pi);

=head2 rotate_90

Returns a new vector object with the x and y values rotated 90 degrees anti-clockwise.

    my $new_vector = $vector->rotate_90;

=head2 dot_product

Returns the dot product. Requires another Math::Shape::Vector object as an argument.

=head2 length

Returns the vector length.

    my $length = $vector->length;

=head2 convert_to_unit_vector

Returns a new vector object with a length of 1.

    my $unit_vector = $vector->convert_to_unit_vector;

=head2 project

Maps the vector to another vector, returning a new vector object. Requires a Math::Shape::Vector object as an argument.

    my $new_vector = $vector->project($vector_2);

=head2 is_parallel

Boolean method that returns 1 if the vector is parallel with another vector else returns zero. Requires a Math::Shape::Vector object as an argument.

    my $v2 = Math::Shape::Vector(1, 2);

    if ($v->is_parallel($v2))
    {
        # do something
    }

=head2 enclosed_angle

Returns the enclosed angle of another vector. Requires a Math::Shape::Vector object as an argument.

    my $v2 = Math::Shape::Vector(4, 2);
    my $enclosed_angle = $v->enclosed_angle($v2);

=head2 collides

Boolean method that returns 1 if the vector collides with another L<Math::Shape::Vector> library object or not or 0 if not. Requires a Math::Shape::Vectorlibrary object as an argument

    my $v1 = Math::Shape::Vector(4, 2);
    my $v2 = Math::Shape::Vector(4, 2);

    $v1->collides($v2); # 1

    my $circle = Math::Shape::Circle->new(0, 0, 3); # x, y and radius
    $v1->collides($circle); # 0

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

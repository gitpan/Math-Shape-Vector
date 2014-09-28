use strict;
use warnings;
package Math::Shape::OrientedRectangle;
$Math::Shape::OrientedRectangle::VERSION = '0.09';
use 5.008;
use Carp;
use Math::Shape::Vector;
use Math::Shape::Utils;
use Math::Shape::LineSegment;

# ABSTRACT: a 2d oriented rectangle


sub new {
    croak 'incorrect number of args' unless @_ == 6;
    my ($class, $x_1, $y_1, $x_2, $y_2, $rotation) = @_;
    bless { center      => Math::Shape::Vector->new($x_1, $y_1),
            half_extend => Math::Shape::Vector->new($x_2, $y_2),
            rotation    => $rotation,
          }, $class;
}


sub get_edge {
    croak 'incorrect number of args' unless @_ == 2;
    my ($self, $edge_number) = @_;

    my $a = Math::Shape::Vector->new(
        $self->{half_extend}->{x},
        $self->{half_extend}->{y});

    my $b = Math::Shape::Vector->new(
        $self->{half_extend}->{x},
        $self->{half_extend}->{y});

    my $mod = $edge_number % 4;

       if ($mod == 0)
    {
        $a->{x} = - $a->{x};
    }
    elsif ($mod == 1)
    {
        $b->{y} = - $b->{y};
    }
    elsif ($mod == 2)
    {
        $a->{y} = - $a->{y};
        $b = $b->negate;
    }
     else
    {
        $a->negate;
        $b->{x} = - $b->{x};
    }

    $a = $a->rotate($self->{rotation});
    $a = $a->add_vector($self->{center});
    $b = $b->rotate($self->{rotation});
    $b = $b->add_vector($self->{center});

    Math::Shape::LineSegment->new($a->{x}, $a->{y}, $b->{x}, $b->{y});
}


sub axis_is_separating
{
    croak 'collides must be called with a Math::Shape::LineSegment object'
        unless $_[1]->isa('Math::Shape::LineSegment');
    my ($self, $axis) = @_;

    my $edge_0 = $self->get_edge(0);
    my $edge_2 = $self->get_edge(2);

    my $n_vector = $axis->{start}->subtract_vector($axis->{end});

    my $axis_range = $axis->project($n_vector);
    my $range_0    = $edge_0->project($n_vector);
    my $range_2    = $edge_2->project($n_vector);
    my $projection = $range_0->get_hull($range_2);

    $axis_range->is_overlapping($projection) ? 0 : 1;
}


sub collides {
    croak 'collides must be called with a Math::Shape::OrientedRectangle object' unless $_[1]->isa('Math::Shape::OrientedRectangle');
    my ($self, $other_obj) = @_;

    my $edge = $self->get_edge(0);
    return 0 if $other_obj->axis_is_separating($edge);

    $edge = $self->get_edge(1);
    return 0 if $other_obj->axis_is_separating($edge);

    $edge = $other_obj->get_edge(0);
    return 0 if $self->axis_is_separating($edge);

    $edge = $other_obj->get_edge(1);
    return 0 if $self->axis_is_separating($edge);

    1;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Math::Shape::OrientedRectangle - a 2d oriented rectangle

=head1 VERSION

version 0.09

=head1 METHODS

=head2 new

Constructor, requires 5 values: the x,y values for the center and the x,y values for the half_extend vector and a rotation number.

    my $OrientedRectangle = Math::Shape::OrientedRectangle->new(1, 1, 2, 4, 45);
    my $width = $OrientedRectangle->{rotation}; # 45

=head2 get_edge

Returns a L<Math::Shape::LineSegment> object for a given edge of the rectangle. Requires a number for the edge of the rectangle to return (0-3).

    my $segment= $oriented_rectangle->get_edge(1);

=head2 axis_is_separating

Boolean method that returns 1 if the axis is separating. Requires a Math::Shape::LineSegment object (for the axis) as an argment.

=head2 collides

Boolean method returns 1 if the OrientedRectangle collides with another OrientedRectangle, else returns 0. Requires another OrientedRectangle object as an argument.

    my $is collision = $OrientedRectangle->collides($other_OrientedRectangle);

=head1 AUTHOR

David Farrell <sillymoos@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by David Farrell.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

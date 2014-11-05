use strict;
use warnings;
package Math::Shape::Circle;
$Math::Shape::Circle::VERSION = '0.09';
use 5.008;
use Carp;
use Math::Shape::Vector;

# ABSTRACT: a 2d circle


sub new {
    croak 'incorrect number of args' unless @_ == 4;
    my ($class, $x, $y, $r) = @_;
    bless { center => Math::Shape::Vector->new($x, $y),
            radius => $r,
          }, $class;
}


sub collides
{
    my ($self, $other_obj) = @_;

    if ($other_obj->isa('Math::Shape::Circle'))
    {
        my $center = $self->{center}->subtract_vector($other_obj->{center});
        $center->length <= $self->{radius} + $other_obj->{radius} ? 1 : 0;
    }
    elsif ($other_obj->isa('Math::Shape::Vector'))
    {
        my $center = $self->{center}->subtract_vector($other_obj);
        $center->length <= $self->{radius} ? 1 : 0;
    }
    elsif ($other_obj->isa('Math::Shape::Line'))
    {
        my $center = $self->{center}->subtract_vector($other_obj->{base});
        my $project = $center->project($other_obj->{direction});

        my $base_vector = $other_obj->{base}->add_vector($project);
        $self->collides($base_vector);
    }
    elsif ($other_obj->isa('Math::Shape::LineSegment'))
    {
        # test collision of both LineSegment start/end points
        return 1 if $self->collides($other_obj->{start});
        return 1 if $self->collides($other_obj->{end});

        # test collision of nearest point on LineSegment with circle
        my $d  = $other_obj->{end}->subtract_vector($other_obj->{start});
        my $lc = $self->{center}->subtract_vector($other_obj->{start});
        my $p  = $lc->project($d);
        my $nearest = $other_obj->{start}->add_vector($p);

        $self->collides($nearest)
            && $p->length <= $d->length
            && 0 <= $p->dot_product($d)
            ? 1 : 0;
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

Math::Shape::Circle - a 2d circle

=head1 VERSION

version 0.09

=head1 METHODS

=head2 new

Constructor, requires 3 values: the x,y values for the center point and a radius

    my $circle = Math::Shape::Circle->new(1, 2, 54);

=head2 collides

Boolean method returns 1 if circle collides with another object, else returns 0. Requires another L<Math::Shape::Vector> library object as an argument.

    my $is_collision = $circle->collides($other_circle);

=head1 AUTHOR

David Farrell <sillymoos@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by David Farrell.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

use strict;
use warnings;
package Math::Shape::Rectangle;
$Math::Shape::Rectangle::VERSION = '0.08';
use 5.008;
use Carp;
use Math::Shape::Vector;
use Math::Shape::Utils;

# ABSTRACT: an axis-aligned 2d rectangle


sub new {
    croak 'incorrect number of args' unless @_ == 5;
    my ($class, $x, $y, $l, $h) = @_;
    bless { origin => Math::Shape::Vector->new($x, $y),
            size   => Math::Shape::Vector->new($l, $h),
          }, $class;
}


sub collides {
    croak 'collides must be called with a Math::Shape::Rectangle object' unless $_[1]->isa('Math::Shape::Rectangle');
    my ($self, $other_rectangle) = @_;

    my $a_left = $self->{origin}->{x};
    my $a_right = $a_left + $self->{size}->{x};
    my $b_left = $other_rectangle->{origin}->{x};
    my $b_right = $b_left + $other_rectangle->{size}->{x};
    my $a_bottom = $self->{origin}->{y};
    my $a_top = $a_bottom + $self->{size}->{y};
    my $b_bottom = $other_rectangle->{origin}->{y};
    my $b_top = $b_bottom + $other_rectangle->{size}->{y};

    overlap($a_left, $a_right, $b_left, $b_right)
    && overlap($a_bottom, $a_top, $b_bottom, $b_top);
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Math::Shape::Rectangle - an axis-aligned 2d rectangle

=head1 VERSION

version 0.08

=head1 METHODS

=head2 new

Constructor, requires 4 values: the x,y values for the origin and the x,y values for the size.

    my $rectangle = Math::Shape::Rectangle->new(1, 1, 2, 4);
    my $width = $rectangle->{size}->{x}; # 2

=head2 collides

Boolean method returns 1 if the rectangle collides with another rectangle, else returns 0. Requires another rectangle object as an argument.

    my $is collision = $rectangle->collides($other_rectangle);

=head1 AUTHOR

David Farrell <sillymoos@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by David Farrell.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

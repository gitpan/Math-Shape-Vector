use strict;
use warnings;
package Math::Shape::Circle;
$Math::Shape::Circle::VERSION = '0.08';
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


sub collides {
    croak 'collides must be called with a Math::Shape::Circle object' unless $_[1]->isa('Math::Shape::Circle');
    my ($self, $other_circle) = @_;

    my $radius_sum = $self->{radius} + $other_circle->{radius};
    my $vector = Math::Shape::Vector->new( $self->{center}->{x}, $self->{center}->{y} );
    $vector->subtract_vector($other_circle->{center});
    $vector->length <= $radius_sum ? 1 :0;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Math::Shape::Circle - a 2d circle

=head1 VERSION

version 0.08

=head1 METHODS

=head2 new

Constructor, requires 3 values: the x,y values for the center point and a radius

    my $circle = Math::Shape::Circle->new(1, 2, 54);

=head2 collides

Boolean method returns 1 if circle collides with another circle, else returns 0. Requires another circle object as an argument.

    my $is collision = $circle->collides($other_circle);

=head1 AUTHOR

David Farrell <sillymoos@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by David Farrell.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

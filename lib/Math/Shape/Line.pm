use strict;
use warnings;
package Math::Shape::Line;
$Math::Shape::Line::VERSION = '0.05';
use 5.008;
use Carp;
use Math::Shape::Vector;

# ABSTRACT: a 2d vector line object - an infinite 2d line


sub new {
    croak 'incorrect number of args' unless @_ == 5;
    my ($class, $x1, $y1, $x2, $y2) = @_;
    bless { base        => Math::Shape::Vector->new($x1, $y1),
            direction   => Math::Shape::Vector->new($x2, $y2),
          }, $class;
}


sub is_equivalent
{
    croak 'must pass a line object' unless $_[1]->isa('Math::Shape::Line');
    if(! $_[0]->{direction}->is_parallel($_[1]->{direction}) )
    {
        return 0;
    }
    my $base = Math::Shape::Vector->new($_[0]->{direction}->{x}, $_[0]->{direction}->{y});
    $base->subtract_vector($_[1]->{base});
    $base->is_parallel($_[0]->{direction});
}


sub collides
{
    croak 'must pass a line object' unless $_[1]->isa('Math::Shape::Line');

    if($_[0]->{direction}->is_parallel($_[1]->{direction}))
    {
        return $_[0]->is_equivalent($_[1]);
    }
    1;
}



1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Math::Shape::Line - a 2d vector line object - an infinite 2d line

=head1 VERSION

version 0.05

=head1 METHODS

=head2 new

Constructor, requires 4 values: the x,y values for the base and direction vectors.

    my $line = Math::Shape::Line->new(1, 2, 3, 4);

=head2 is_equivalent

Boolean method returns 1 if the line is equivalent to another line object. Requires a Math::Shape::Line object as an argument.

=head2 collides

Boolean method that returns 1 if the line collides with another line or 0 if not. Requires a Math::Shape::Line object as an argument

    my $l1 = Math::Shape::Line(4, 2);
    my $l2 = Math::Shape::Line(4, 2);

    $l1->collides($l2); # 1

=head1 AUTHOR

David Farrell <sillymoos@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by David Farrell.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

use strict;
use warnings;
use Test::More;
use Math::Shape::LineSegment;

BEGIN { use_ok 'Math::Shape::Line' };

# new
ok my $line1 = Math::Shape::Line->new(1, 1, 1, 1), 'constructor';
ok my $line2 = Math::Shape::Line->new(2, 4, 2, 1), 'constructor';
ok my $line3 = Math::Shape::Line->new(2, 4, 2, 1), 'constructor';

# equivalent
is $line1->is_equivalent($line2), 0;
is $line2->is_equivalent($line1), 0;
is $line2->is_equivalent($line3), 0;

# on_one_side
my $segment = Math::Shape::LineSegment->new(1, 3, 4, 8);
is $line1->on_one_side($segment), 1;
is $line2->on_one_side($segment), 0;

# collides
is $line1->collides($line2), 1;
is $line2->collides($line1), 1;
is $line2->collides($line3), 0;

ok my $line4 = Math::Shape::Line->new(3, 3, 2, 2);
ok my $line5 = Math::Shape::Line->new(1, 5, 2, 2);
is $line4->{direction}->is_parallel($line5->{direction}), 1;
is $line4->collides($line5), 0;

done_testing();


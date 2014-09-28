use strict;
use warnings;
use Test::More;
use Math::Shape::LineSegment;

BEGIN { use_ok 'Math::Shape::Line' };

# new
ok my $line1 = Math::Shape::Line->new(1, 1, 1, 1);
ok my $line2 = Math::Shape::Line->new(2, 2, 1, 1);
ok my $line3 = Math::Shape::Line->new(2, 4, 2, 1);
ok my $line4 = Math::Shape::Line->new(1, 3, 1, 1);
ok my $line5 = Math::Shape::Line->new(1, 5, 1, 3);

# equivalent
is $line1->is_equivalent($line2), 1;
is $line2->is_equivalent($line3), 0;
is $line3->is_equivalent($line4), 0;
is $line4->is_equivalent($line5), 0;

# on_one_side
my $segment = Math::Shape::LineSegment->new(1, 3, 4, 8);
is $line1->on_one_side($segment), 1;
is $line2->on_one_side($segment), 1;
is $line3->on_one_side($segment), 0;
is $line4->on_one_side($segment), 0;
is $line5->on_one_side($segment), 1;

# collides
is $line1->collides($line2), 1;
is $line1->collides($line4), 0;
is $line2->collides($line3), 1;
is $line3->collides($line4), 1;
is $line4->collides($line5), 1;

done_testing();


use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Math::Shape::Rectangle' };

# new
ok my $rect1 = Math::Shape::Rectangle->new(1, 1, 2, 4);
ok my $rect2 = Math::Shape::Rectangle->new(1, 1, 10, 10);
ok my $rect3 = Math::Shape::Rectangle->new(1, 4, 1, 1);
ok my $rect4 = Math::Shape::Rectangle->new(5, 100, 10, 10);
is $rect1->{origin}->{x}, 1;
is $rect1->{origin}->{y}, 1;
is $rect1->{size}->{x}, 2;
is $rect1->{size}->{y}, 4;

# collides
is $rect1->collides($rect2), 1;
is $rect1->collides($rect3), 1;
is $rect1->collides($rect4), 0;
is $rect2->collides($rect3), 1;
is $rect2->collides($rect4), 0;
is $rect3->collides($rect4), 0;

done_testing();


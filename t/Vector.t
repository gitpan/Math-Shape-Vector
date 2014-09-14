use strict;
use warnings;
use Test::More;
use Test::Exception;
use Math::Shape::Point 1.05;
use Math::Trig ':pi';

BEGIN { use_ok 'Math::Shape::Vector', 'import module' };

# new
ok my $v = Math::Shape::Vector->new(1,2),        'constructor';
ok my $v2 = Math::Shape::Vector->new(1,1),       'constructor';
dies_ok sub { Math::Shape::Vector->new(1) },     'constructor dies on too few args';
dies_ok sub { Math::Shape::Vector->new(1,2,3) }, 'constructor dies on too many args';

# add_vector
ok $v->add_vector($v2), 'add vector';
is $v->{x}, 2,          'x is now 2';
is $v->{y}, 3,          'y is now 3';
ok $v2->add_vector($v), 'add vector';
is $v2->{x}, 3,          'x is now 3';
is $v2->{y}, 4,          'y is now 4';
dies_ok sub { $v->add_vector(1,2) }, 'add vector wrong args';
dies_ok sub { $v->add_vector( Math::Shape::Point->new(1,2,3) ) }, 'add vector wrong args';

# subtract_vector
ok my $v3 = Math::Shape::Vector->new(4,2),        'constructor';
ok my $v4 = Math::Shape::Vector->new(1,1),       'constructor';
ok $v3->subtract_vector($v4),   'subtract vector';
is $v3->{x}, 3,                 'x is now 3';
is $v3->{y}, 1,                 'y is now 1';
ok $v4->subtract_vector($v3),   'subtract vector';
is $v4->{x}, -2,                'x is now 3';
is $v4->{y}, 0,                 'y is now 4';
dies_ok sub { $v3->subtract_vector(1,2) }, 'subtract vector wrong args';
dies_ok sub { $v4->subtract_vector( Math::Shape::Point->new(1,2,3) ) }, 'subtract vector wrong args';

# is_equal
ok my $v5 = Math::Shape::Vector->new(4,2);
ok my $v6 = Math::Shape::Vector->new(1,1);
ok my $v7 = Math::Shape::Vector->new(1,1);
is $v5->is_equal($v6), 0;
is $v5->is_equal($v7), 0;
is $v6->is_equal($v6), 1;
is $v6->is_equal($v7), 1;
is $v7->is_equal($v6), 1;
dies_ok sub { $v5->is_equal(1,2) }, 'is_equal wrong args';
dies_ok sub { $v5->subtract_vector( Math::Shape::Point->new(1,2,3) ) }, 'is_equal wrong args';

# negate
ok my $v8 = Math::Shape::Vector->new(1, 1);
ok my $v9 = Math::Shape::Vector->new(-3,3);
ok $v8->negate;
is $v8->{x}, -1, 'x is now -1';
is $v8->{y}, -1, 'y is now -1';
ok $v9->negate;
is $v9->{x},  3, 'x is now 3';
is $v9->{y}, -3, 'y is now -3';

# multiply
ok my $v10 = Math::Shape::Vector->new(1, 1);
ok $v10->multiply(9);
is $v10->{x}, 9, 'x is now 9';
is $v10->{y}, 9, 'y is now 9';
dies_ok sub { $v10->multiply(1,2,3) }, 'multiply wrong args';

# divide
ok my $v11 = Math::Shape::Vector->new(5, 5);
ok $v11->divide(5);
is $v11->{x}, 1, 'x is now 1';
is $v11->{y}, 1, 'y is now 1';
dies_ok sub { $v11->divide(1,3) }, 'divide wrong args';

# length
ok my $v12 = Math::Shape::Vector->new(5, 5);
ok my $v13 = Math::Shape::Vector->new(7, 3);
ok my $v14 = Math::Shape::Vector->new(0, 0);
is sprintf( "%.3f", $v12->length), 7.071;
is sprintf( "%.3f", $v13->length), 7.616;
is $v14->length, 0, 'null vector length is zero';

# convert to unit vector
ok my $v15 = Math::Shape::Vector->new(5, 5);
ok my $v16 = Math::Shape::Vector->new(7, 3);
ok my $v17 = Math::Shape::Vector->new(0, 0);
ok $v15->convert_to_unit_vector;
ok $v16->convert_to_unit_vector;
ok $v17->convert_to_unit_vector;
is $v15->length, 1;
is $v16->length, 1;
is $v17->length, 0;

# rotate
ok my $v18 = Math::Shape::Vector->new(5, 5);
ok my $v19 = Math::Shape::Vector->new(7, 3);
ok my $v20 = Math::Shape::Vector->new(0, 0);
ok $v18->rotate(pi);
ok $v19->rotate(pi2);
ok $v20->rotate(0);
is $v18->{x}, -5;
is $v19->{x}, 7;
is $v20->{x}, 0;

# dot_product
ok my $v21 = Math::Shape::Vector->new(8, 2);
ok my $v22 = Math::Shape::Vector->new(-2, 8);
ok my $v23 = Math::Shape::Vector->new(-5, 5);
   # this is the dot product formula
is $v21->{x} * $v22->{x} + $v21->{y} * $v22->{y}, $v21->dot_product($v22);
is $v22->{x} * $v23->{x} + $v22->{y} * $v23->{y}, $v22->dot_product($v23);
is $v23->{x} * $v21->{x} + $v23->{y} * $v21->{y}, $v23->dot_product($v21);

# project
ok my $v24 = Math::Shape::Vector->new(8, 2);
ok my $v25 = Math::Shape::Vector->new(-2, 8);
ok my $v26 = Math::Shape::Vector->new(-2, 8);
is $v24->project($v25)->{x}, 8;
is $v25->project($v26)->{x}, 0;

# collides
ok my $v27 = Math::Shape::Vector->new(8, 2);
ok my $v28 = Math::Shape::Vector->new(-2, 8);
ok my $v29 = Math::Shape::Vector->new(-2, 8);
is $v27->collides($v28), 0;
is $v28->collides($v29), 1;
is $v29->collides($v27), 0;


# enclosed angle
# rotate_90
ok my $v30 = Math::Shape::Vector->new(3, 8);
ok $v30->rotate_90;
is $v30->{x}, -8;
is $v30->{y}, 3;
done_testing();

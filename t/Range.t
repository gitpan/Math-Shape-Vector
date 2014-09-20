use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Math::Shape::Range' };

# new
ok my $r1 = Math::Shape::Range->new(54, 89.05), 'constructor';
is $r1->{min}, 54;
is $r1->{max}, 89.05;

# sort
ok $r1->sort, 'values should not change';
is $r1->{min}, 54;
is $r1->{max}, 89.05;

ok my $r2 = Math::Shape::Range->new(71.5, 71.05), 'constructor';
ok $r2->sort, 'values should swap';
is $r2->{min}, 71.05;
is $r2->{max}, 71.5;

# is_overlapping
ok my $r3 = Math::Shape::Range->new(1, 10), 'constructor';
ok my $r4 = Math::Shape::Range->new(9, 11), 'constructor';
ok my $r5 = Math::Shape::Range->new(11,20), 'constructor';
is $r3->is_overlapping($r4), 1;
is $r4->is_overlapping($r5), 1;
is $r5->is_overlapping($r3), 0;
done_testing();


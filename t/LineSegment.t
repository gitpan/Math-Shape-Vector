use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Math::Shape::Line' };

ok my $line = Math::Shape::Line->new(1, 1, 1, 1), 'constructor';

done_testing();


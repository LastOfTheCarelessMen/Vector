use v6;

use Test;
use Vector;
use SVGPad;

plan *;

my $pad = SVGPad.new(Vector.new(-1, 0), Vector.new(1, 3), Vector.new(0, 0), Vector.new(200, 300));
isa_ok($pad, SVGPad, "Variable is of type SVGPad");
is_approx($pad.xy_min, Vector.new(-1, 0), "xy_min is correct");
is_approx($pad.xy_max, Vector.new(1, 3), "xy_max is correct");
is_approx($pad.mn_min, Vector.new(0, 0), "mn_min is correct");
is_approx($pad.mn_max, Vector.new(200, 300), "mn_max is correct");


done_testing;
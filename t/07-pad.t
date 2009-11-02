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

is_approx($pad.xy2mn(Vector.new(-1, 0)), Vector.new(0, 0), "(-1, 0) goes to (0, 0)");
is_approx($pad.xy2mn(Vector.new(0, 0)), Vector.new(100, 0), "(0, 0) is (100, 0)");
is_approx($pad.xy2mn(Vector.new(1, 0)), Vector.new(200, 0), "(1, 0) is (200, 0)");
is_approx($pad.xy2mn(Vector.new(-1, 1)), Vector.new(0, 100), "(-1, 1) goes to (0, 100)");
is_approx($pad.xy2mn(Vector.new(0, 1)), Vector.new(100, 100), "(0, 1) is (100, 100)");
is_approx($pad.xy2mn(Vector.new(1, 1)), Vector.new(200, 100), "(1, 1) is (200, 100)");
is_approx($pad.xy2mn(Vector.new(-1, 3)), Vector.new(0, 300), "(-1, 3) goes to (0, 300)");
is_approx($pad.xy2mn(Vector.new(0, 3)), Vector.new(100, 300), "(0, 3) is (100, 300)");
is_approx($pad.xy2mn(Vector.new(1, 3)), Vector.new(200, 300), "(1, 3) is (200, 300)");


done_testing;
use v6;
use KnotVector;
use Test;

plan *;

multi sub N(@u, $i, $p where { $p == 0 }, $u, KnotBasisDirection $direction = Left)
{
    given $direction
    {
        when Left { return 1 if @u[$i] <= $u < @u[$i + 1]; }
        when Right { return 1 if @u[$i] < $u <= @u[$i + 1]; }
    }
    return 0;
}

multi sub N(@u, $i, $p, $u, KnotBasisDirection $direction = Left)
{
    (($u - @u[$i]) O/ (@u[$i + $p] - @u[$i])) * N(@u, $i, $p - 1, $u, $direction)
    + ((@u[$i + $p + 1] - $u) O/ (@u[$i + $p + 1] - @u[$i + 1])) * N(@u, $i + 1, $p - 1, $u, $direction);
}

multi sub RangeOfSize($a, $b, $size)
{
    my $delta = ($b - $a) / ($size - 1);
    my $value = $a; 
    return gather
    {
        loop (my $i = 0; $i + 1 < $size; $i++)
        {
            my $result = $value;
            take $result;
            $value += $delta;
        }
        take $b;
    }
}

my @knots = (0, 0, 1, 1);
is_approx(N(@knots, 0, 0, -1), 0, "Before first knot is 0");
is_approx(N(@knots, 0, 0, 0), 0, "At first knot is 0");
is_approx(N(@knots, 0, 0, .25), 0, "Between knots is 0");
is_approx(N(@knots, 0, 0, 1), 0, "At last knot is 0");
is_approx(N(@knots, 0, 0, 2), 0, "After last knot is 0");

is_approx(N(@knots, 1, 0, -1), 0, "Before first knot is 0");
is_approx(N(@knots, 1, 0, 0), 1, "At first knot is 1");
is_approx(N(@knots, 1, 0, .25), 1, "Between knots is 1");
is_approx(N(@knots, 1, 0, 1), 0, "At last knot is 0");
is_approx(N(@knots, 1, 0, 2), 0, "After last knot is 0");

is_approx(N(@knots, 2, 0, -1), 0, "Before first knot is 0");
is_approx(N(@knots, 2, 0, 0), 0, "At first knot is 0");
is_approx(N(@knots, 2, 0, .25), 0, "Between knots is 0");
is_approx(N(@knots, 2, 0, 1), 0, "At last knot is 0");
is_approx(N(@knots, 2, 0, 2), 0, "After last knot is 0");

is_approx(N(@knots, 0, 1, -1), 0, "N_0_1(-1) is 0");
is_approx(N(@knots, 1, 1, -1), 0, "N_1_1(-1) is 0");
is_approx(N(@knots, 0, 1, 0), 1, "N_0_1(-1) is 1 (left hand math)");
is_approx(N(@knots, 1, 1, 0), 0, "N_1_1(-1) is 0 (left hand math)");
is_approx(N(@knots, 0, 1, 0, Right), 0, "N_0_1(-1) is 0 (right hand math)");
is_approx(N(@knots, 1, 1, 0, Right), 0, "N_1_1(-1) is 0 (right hand math)");
for RangeOfSize(0.0001, 0.9999, 10) -> $u
{
    is_approx(N(@knots, 0, 1, $u), 1 - $u, "N_0_1($u) is {1 - $u}");
    is_approx(N(@knots, 1, 1, $u), $u, "N_1_1($u) is $u got {N(@knots, 1, 1, $u)}");
    is_approx(N(@knots, 0, 1, $u, Right), N(@knots, 0, 1, $u, Left), "right hand agrees with left hand");
    is_approx(N(@knots, 1, 1, $u, Right), N(@knots, 1, 1, $u, Left), "right hand agrees with left hand");
}
is_approx(N(@knots, 0, 1, 1), 0, "N_0_1(1) is 0 (left hand math)");
is_approx(N(@knots, 1, 1, 1), 0, "N_1_1(1) is 0 (left hand math)");
is_approx(N(@knots, 0, 1, 1, Right), 0, "N_0_1(1) is 0 (right hand math)");
is_approx(N(@knots, 1, 1, 1, Right), 1, "N_1_1(1) is 1 (right hand math)");
is_approx(N(@knots, 0, 1, 2), 0, "N_0_1(2) is 0");
is_approx(N(@knots, 1, 1, 2), 0, "N_1_1(2) is 0");

my $kv = KnotVector.new(@knots);
isa_ok($kv, KnotVector, "Variable is of type KnotVector");
is(~eval($kv.perl), ~$kv, ".perl works, tested with Str");
isa_ok(eval($kv.perl), KnotVector, ".perl works, tested with isa");

is($kv.N0_index(1, 0.0), 0, "KnotVector.N0_index(0.0) == 0");
is($kv.N0_index(1, 0.5), 0, "KnotVector.N0_index(0.5) == 0");

is($kv.N(1, 0.0), (1, 0), "KnotVector.N degree 1 at 0 == (1, 0)");
is($kv.N(1, 1.0, Right), (0, 1), "KnotVector.N degree 1 at 1 (Right) == (0, 1)");

is($kv.N(1, 0.5), (0..1).map({ N(@knots, $_, 1, 0.5) }), "KnotVector.N degree 1 matches test N");
is($kv.N(1, 0.5, Right), (0..1).map({ N(@knots, $_, 1, 0.5) }), "KnotVector.N degree 1 matches test N (Right)");

my @knots2 = (0, 0, 0, 1, 2, 2, 2);
$kv = KnotVector.new(@knots2);
is($kv.N(2, 0.0), (0..3).map({ N(@knots2, $_, 2, 0.0) }), "KnotVector.N degree 2 matches test N for 0.0");
is($kv.N(2, 0.25), (0..3).map({ N(@knots2, $_, 2, 0.25) }), "KnotVector.N degree 2 matches test N for 0.25");
is($kv.N(2, 0.5), (0..3).map({ N(@knots2, $_, 2, 0.5) }), "KnotVector.N degree 2 matches test N for 0.5");
is($kv.N(2, 1.25), (0..3).map({ N(@knots2, $_, 2, 1.25) }), "KnotVector.N degree 2 matches test N for 1.25");
is($kv.N(2, 0.25, Right), (0..3).map({ N(@knots2, $_, 2, 0.25) }), 
   "KnotVector.N degree 2 matches test N for 0.25 from the Right");
is($kv.N(2, 0.5, Right), (0..3).map({ N(@knots2, $_, 2, 0.5) }), 
   "KnotVector.N degree 2 matches test N for 0.5 from the Right");
is($kv.N(2, 1.25, Right), (0..3).map({ N(@knots2, $_, 2, 1.25) }), 
   "KnotVector.N degree 2 matches test N for 1.25 from the Right");
is($kv.N(2, 2.0, Right), (0..3).map({ N(@knots2, $_, 2, 2.0, Right) }), 
   "KnotVector.N degree 2 matches test N for 2.0 from the Right");


done_testing;
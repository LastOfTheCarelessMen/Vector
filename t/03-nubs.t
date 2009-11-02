use v6;
use KnotVector;
use Nurbs;
use Vector;
use Test;

plan *;

my $kv = KnotVector.new((0, 0, 1, 1));
my $nubs1 = Nubs.new(1, $kv, (Vector.new(0, 0, 0, 0), Vector.new(1, 10, 100, 1000)));
isa_ok($nubs1, Nubs, "Variable is of type Nubs");
is(eval($nubs1.perl).degree, $nubs1.degree, ".perl works for degree");
is(eval($nubs1.perl).knot_vector, $nubs1.knot_vector, ".perl works for knot vector");
is(eval($nubs1.perl).control_points, $nubs1.control_points, ".perl works for control points");
isa_ok(eval($nubs1.perl), Nubs, ".perl works, tested with isa");
is_approx($nubs1.ParameterRange()[0], 0, "ParameterRange starts at 0");
is_approx($nubs1.ParameterRange()[1], 1, "ParameterRange ends at 1");

is_approx_vector($nubs1.evaluate(0.0), Vector.new(0, 0, 0, 0), "\$nubs1.evaluate(0.0) is (0, 0, 0, 0)");
is_approx_vector($nubs1.evaluate(0.4), Vector.new(0.4, 4, 40, 400), "\$nubs1.evaluate(0.4) is (0.4, 4, 40, 400)");

my $nubs2 = Nubs.new(1, $kv, (Vector.new(1, 10, 100, 1000), Vector.new(0, 0, 0, 0)));
is_approx_vector($nubs2.evaluate(0.0), Vector.new(1, 10, 100, 1000), "\$nubs2.evaluate(0.0) is (1, 10, 100, 1000)");

# hardcore tests

my @control_points = (Vector.new(-1, -2, -3),
                      Vector.new(1, 0, 0),
                      Vector.new(1, 1, 0),
                      Vector.new(0, 1, 0),
                      Vector.new(1, 2, 0),
                      Vector.new(1, 2, 1),
                      Vector.new(1, 2, -1));
my @knots = (-1, -1, -1, -1, 1, 2, 2, 3, 3, 3, 3);
my Nubs $nubs = Nubs.new(3, KnotVector.new(@knots), @control_points);
is_approx($nubs.ParameterRange()[0], -1, "ParameterRange starts at -1");
is_approx($nubs.ParameterRange()[1], 3, "ParameterRange ends at 3");

is_approx_vector $nubs.evaluate(-1), Vector.new(-1, -2, -3), "\$nubs.evaluate(-1) is (-1, -2, -3)";
is_approx_vector $nubs.evaluate(3.0, Right), Vector.new(1, 2, -1), "\$nubs.evaluate(3.0) is (1, 2, -1)";

my $translation = Vector.new(3, 4.0, 5);
my Nubs $nubs3 = Nubs.new(3, KnotVector.new(@knots), @control_points >>+>> $translation);

for RangeOfSize(-1, 3, 10) -> $t
{
    my $direction = $t < 3 ?? Left !! Right;
    is_approx_vector $nubs3.evaluate($t, $direction), 
                     $nubs.evaluate($t, $direction) + $translation, 
                     "\$nubs3.evaluate($t, {$direction.perl}) == \$nubs.evaluate($t, {$direction.perl}) + \$translation";
    is_approx_vector $nubs3.evaluate($t), $nubs.evaluate($t) + $translation, 
                     "\$nubs3.evaluate($t) == \$nubs.evaluate($t) + \$translation";
}

done_testing;
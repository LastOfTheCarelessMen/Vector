use v6;
use KnotVector;
use Nurbs;
use Vector;
use Test;

sub is_approx_vector(Vector $a, Vector $b, $desc)
{
    ok(($a - $b).Length < 0.00001, $desc);
}

plan *;

my $kv = KnotVector.new((0, 0, 1, 1));
my $nubs1 = Nubs.new(1, $kv, (Vector.new(0, 0, 0, 0), Vector.new(1, 10, 100, 1000)));
isa_ok($nubs1, Nubs, "Variable is of type Nubs");
is(eval($nubs1.perl).degree, $nubs1.degree, ".perl works for degree");
is(eval($nubs1.perl).knot_vector, $nubs1.knot_vector, ".perl works for knot vector");
is(eval($nubs1.perl).control_points, $nubs1.control_points, ".perl works for control points");
isa_ok(eval($nubs1.perl), Nubs, ".perl works, tested with isa");

is_approx_vector($nubs1.Evaluate(0.0), Vector.new(0, 0, 0, 0), "\$nubs1.Evaluate(0.0) is (0, 0, 0, 0)");
is_approx_vector($nubs1.Evaluate(0.4), Vector.new(0.4, 4, 40, 400), "\$nubs1.Evaluate(0.4) is (0.4, 4, 40, 400)");

my $nubs2 = Nubs.new(1, $kv, (Vector.new(1, 10, 100, 1000), Vector.new(0, 0, 0, 0)));
is_approx_vector($nubs2.Evaluate(0.0), Vector.new(1, 10, 100, 1000), "\$nubs2.Evaluate(0.0) is (1, 10, 100, 1000)");

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

is_approx_vector $nubs.Evaluate(-1), Vector.new(-1, -2, -3), "\$nubs.Evaluate(-1) is (-1, -2, -3)";
is_approx_vector $nubs.Evaluate(3.0, Right), Vector.new(1, 2, -1), "\$nubs.Evaluate(3.0) is (1, 2, -1)";

my $translation = Vector.new(3, 4.0, 5);
my Nubs $nubs3 = Nubs.new(3, KnotVector.new(@knots), @control_points >>+>> $translation);

for RangeOfSize(-1, 3, 10) -> $t
{
    my $direction = $t < 3 ?? Left !! Right;
    is_approx_vector $nubs3.Evaluate($t, $direction), 
                     $nubs.Evaluate($t, $direction) + $translation, 
                     "\$nubs3.Evaluate($t) == \$nubs.Evaluate($t) + \$translation";
}

done_testing;
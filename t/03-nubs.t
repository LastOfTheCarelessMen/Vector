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
is_approx_vector($nubs1.Evaluate(0.0), Vector.new(0, 0, 0, 0), "\$nubs1.Evaluate(0.0) is (0, 0, 0, 0)");
is_approx_vector($nubs1.Evaluate(0.4), Vector.new(0.4, 4, 40, 400), "\$nubs1.Evaluate(0.4) is (0.4, 4, 40, 400)");

done_testing;
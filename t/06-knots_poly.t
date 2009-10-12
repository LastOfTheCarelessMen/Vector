use v6;
use KnotVector;
use Polynomial;
use Nurbs;
use Test;

plan *;

my @control_points = (Vector.new(0, 0, 0),
                      Vector.new(1, 0, 0),
                      Vector.new(1, 1, 0),
                      Vector.new(0, 1, 0),
                      Vector.new(1, 2, 0),
                      Vector.new(1, 2, 1),
                      Vector.new(1, 2, -1));

# First test that you can have a Polynomial with Vector coefficients

{
    my $pv1 = Polynomial.new(Vector.new(0, 0, 1), Vector.new(1, 0, 0));
    isa_ok($pv1, Polynomial, "Vector-valued Polynomial is a Polynomial");
    is_approx($pv1.evaluate(0), Vector.new(0, 0, 1), "pv1 evaluates correctly for x = 0");
    is_approx($pv1.evaluate(1), Vector.new(1, 0, 1), "pv1 evaluates correctly for x = 1");
    my $pv2 = eval($pv1.perl);
    isa_ok($pv2, Polynomial, "Vector-valued Polynomial (cycled through .perl and .eval) is a Polynomial");
    is_approx($pv2.evaluate(0), Vector.new(0, 0, 1), "pv2 evaluates correctly for x = 0");
    is_approx($pv2.evaluate(1), Vector.new(1, 0, 1), "pv2 evaluates correctly for x = 1");
    my $pv3 = Polynomial.new(@control_points);
    isa_ok($pv1, Polynomial, "Vector-valued Polynomial from array is a Polynomial");
    my $pv4 = $pv1 + $pv3;
    my $pv5 = -$pv3;
}

# Okay, now test the KnotVector plus Vector plus Polynomial craziness
 
my KnotVector $kv = KnotVector.new((-1, -1, -1, -1, 1, 2, 2, 3, 3, 3, 3));

my Nubs $nubs = Nubs.new(3, $kv, @control_points);

my @polys = Polynomial.new(0) xx 7;
my $n0 = $kv.N0_index(1/2);
@polys[($n0 - 4) .. ($n0 - 1)] = $kv.N_local($n0, 3, Polynomial.new(0, 1));

my @temp = (@polys >>*<< @control_points);
# say "by the first hurdle";
# @temp>>.say;
my $poly = [+] @temp;

for (-1, -1/2, 0, 1/2) -> $t
{
    my @values = @polys>>.evaluate($t);
    my $value = [+] (@values >>*<< @control_points);
    is_approx($value, $nubs.Evaluate($t), "Polynomial evaluation and sum == Nubs evaluation");
}

done_testing;
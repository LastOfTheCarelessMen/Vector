use v6;
use KnotVector;
use Polynomial;
use Nurbs;
use Test;

plan *;

my KnotVector $kv = KnotVector.new((-1, -1, -1, -1, 1, 2, 2, 3, 3, 3, 3));
my @control_points = (Vector.new(0, 0, 0),
                      Vector.new(1, 0, 0),
                      Vector.new(1, 1, 0),
                      Vector.new(0, 1, 0),
                      Vector.new(1, 2, 0),
                      Vector.new(1, 2, 1),
                      Vector.new(1, 2, -1));
my Nubs $nubs = Nubs.new(3, $kv, @control_points);

my @polys = Polynomial.new(0) xx 7;
my $n0 = $kv.N0_index(1/2);
@polys[($n0 - 4) .. ($n0 - 1)] = $kv.N_local($n0, 3, Polynomial.new(0, 1));

for (-1, -1/2, 0, 1/2) -> $t
{
    my @values = @polys>>.evaluate($t);
    my $value = [+] (@values >>*<< @control_points);
    is_approx($value, $nubs.Evaluate($t), "Polynomial evaluation and sum == Nubs evaluation");
    # my @frip = (@polys Z @control_points).map({ $^a * $^b });
    # my $poly = [+] (@polys >>*<< @control_points);
    # $poly.say;
    # # @polys.map({ $_.evaluate(1/2).perl.say });
}

done_testing;
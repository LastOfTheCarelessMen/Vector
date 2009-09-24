use v6;
use Vector;
use Polynomial;
use KnotVector;

my Vector $v1 = Vector.new(1,2,3);
my Vector $v2 = Vector.new(3,4,5);
say $v1;
say $v2;
say $v1 + $v2;
say $v1 - $v2;
say -$v2;
say $v1 ⋅ $v2;
say $v1 dot $v2;
say $v1 × $v2;
say $v1 cross $v2;
say $v1.Length;
say ⎡$v1⎤;
say $v1.Unitize;
$v1 += $v2;
say $v1;

say " ";

my Vector $v7 = Vector.new(1,2,3,4,5,6,7);
my Vector $v8 = Vector.new(0,1,0,1,0,1,0);
say $v7;
say $v8;
say $v7 + $v8;
say $v7 × $v8;
say $v7 dot ($v7 × $v8);
say $v8 dot ($v7 × $v8);

my $vs = Vector.new(1, 1, 1);
say $vs.Unitize;

my $p = Polynomial.new(1.0, 2.0, 3.0);
say $p.perl;
say $p;
say $p.evaluate(0.0);
say $p.evaluate(0.5);
say $p.evaluate(1.0);
my $p2 = Polynomial.new(0.0, 0.0, 3.0, 5.0, 6.0);
say $p + $p2;
say $p + 3;
say 5 + $p;
my $p3 = Polynomial.new();
say $p3;
say $p * Polynomial.new(0.0, 1.0);
say $p * $p;

my KnotVector $kv = KnotVector.new((0, 0, 0, 0, 1, 2, 2, 3, 3, 3, 3));
say $kv;
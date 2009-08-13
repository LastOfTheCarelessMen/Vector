use v6;
use Vector;

my Vector $v1 = Vector.new(1,2,3);
my Vector $v2 = Vector.new(3,4,5);
say $v1;
say $v2;
say $v1 ⊕ $v2;
say $v1 ∇ $v2;
say ∇$v2;
say $v1 ⋅ $v2;
say $v1 dot $v2;
say $v1 × $v2;
say $v1 cross $v2;
say $v1.LengthSquared;
say $v1.Length;
say ⎡$v1⎤;
say $v1.Unitize;
$v1 ⊕= $v2;
say $v1;

say " ";

my Vector $v7 = Vector.new(1,2,3,4,5,6,7);
my Vector $v8 = Vector.new(0,1,0,1,0,1,0);
say $v7;
say $v8;
say $v7 ⊕ $v8;
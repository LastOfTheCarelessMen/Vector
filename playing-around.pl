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
say $v1 × $v2;
say $v1.LengthSquared;
say $v1.Length;
say $v1.Unitize;

use v6;
use Vector;
use Test;

plan *;

my $v1 = Vector.new(1, 2, 3);
my Vector $v2 = Vector.new(3, 4, 0);
my Vector $v3 = Vector.new(-1, 0, 2);
my Vector $origin3d = Vector.new(0, 0, 0);

isa_ok($v1, Vector, "Variable is of type Vector");
isa_ok($v2, Vector, "Variable is of type Vector");

is(~($v1 ⊕ $v2), "(4, 6, 3)", "Basic sum works properly");
is($v1 ⊕ $v2, $v2 ⊕ $v1, "Addition is commutative");
is(($v1 ⊕ $v2) ⊕ $v3, $v1 ⊕ ($v2 ⊕ $v3), "Addition is associative");
is($v1 ⊕ $origin3d, $v1, "Addition with origin leaves original");


done_testing;
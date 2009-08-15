use v6;
use Vector;
use Test;

# sub is_approx_ok(Num $a, Num $b, Str $mess)
# {
#     
# }

plan *;

my $v1 = Vector.new(1, 2, 3);
my Vector $v2 = Vector.new(3, 4, 0);
my @v3 = (-1, 0, 2);
my Vector $v3 = Vector.new(@v3);
my Vector $origin3d = Vector.new(0, 0, 0);
my Vector $v5 = Vector.new(1,2,3,4,5);
my Vector $v6 = Vector.new(0,0,1,0,0);
my Vector $v7 = Vector.new(1,0,0,0,0,0,0);
my Vector $v8 = Vector.new(0,1,0,0,0,0,0);
my Vector $v9 = Vector.new(0,0,1,0,0,0,0);

isa_ok($v1, Vector, "Variable is of type Vector");
isa_ok($v2, Vector, "Variable is of type Vector");
isa_ok($v3, Vector, "Variable is of type Vector");
isa_ok($v5, Vector, "Variable is of type Vector");
isa_ok($v7, Vector, "Variable is of type Vector");

is(~$v1, "(1, 2, 3)", "Stringify works");
is(~$v3, "(-1, 0, 2)", "Stringify works");
is(~$origin3d, "(0, 0, 0)", "Stringify works");
is(~$v5, "(1, 2, 3, 4, 5)", "Stringify works");

is($v1.Dim, 3, "Dim works for 3D Vector");
is($v5.Dim, 5, "Dim works for 5D Vector");
is($v7.Dim, 7, "Dim works for 7D Vector");

is(~($v1 ⊕ $v2), "(4, 6, 3)", "Basic sum works");
is(~($v7 ⊕ $v9), "(1, 0, 1, 0, 0, 0, 0)", "Basic sum works, 7D");
is($v1 ⊕ $v2, $v2 ⊕ $v1, "Addition is commutative");
is(($v1 ⊕ $v2) ⊕ $v3, $v1 ⊕ ($v2 ⊕ $v3), "Addition is associative");
is($v1 ⊕ $origin3d, $v1, "Addition with origin leaves original");

is($origin3d.Length, 0, "Origin has 0 length");
is($v6.Length, 1, "Simple length calculation");
is($v8.Length, 1, "Simple length calculation");

is(~($v1 ∇ $v2), "(-2, -2, 3)", "Basic subtraction works");
is($v1 ∇ $v2, ∇($v2 ∇ $v1), "Subtraction is anticommutative");
is($v1 ∇ $origin3d, $v1, "Subtracting the origin leaves original");
is(∇$origin3d, $origin3d, "Negating the origin leaves the origin");
is(~(∇$v2), "(-3, -4, 0)", "Negating works");

#cross product tests
dies_ok( { $v1 × $v7 }, "You can't do cross products of different dimensions");
dies_ok( { $v5 × $v6 }, "You can't do 5D cross products");




done_testing;
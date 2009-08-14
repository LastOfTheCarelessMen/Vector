use v6;
use Vector;
use Test;

plan *;

my $v1 = Vector.new(1,2,3);
my Vector $v2 = Vector.new(3,4,0);

isa_ok($v1, Vector, "Variable is of type Vector");
isa_ok($v2, Vector, "Variable is of type Vector");



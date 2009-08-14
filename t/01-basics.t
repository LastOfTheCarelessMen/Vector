use v6;
use Vector;
use Test;

plan 1;

my $v1 = Vector.new(1,2,3);

isa_ok($v1, Vector, "Variable is of type Vector");
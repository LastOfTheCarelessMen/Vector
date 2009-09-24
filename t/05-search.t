use v6;
use BinarySearch;
use Test;

plan *;

my @array = (1, 2, 2, 3, 4, 5, 5, 5, 5, 6, 7, 8);

say [<=] @array;
ok([<=] @array, "array is sorted properly");

for (0.5, 1.5, 2, 2.5, 3, 3.5, 4, 5.5, 6, 8) -> $x
{
    my $i = LowerBound(@array, $x);
    ok(@array[$i - 1] < $x <= @array[$i], "lower bound - 1 < $x <= lower bound");
}

is(LowerBound(@array, 8.5), @array.elems, "Off the big end returns max_index + 1");

is(UpperBound(@array, 0.5), 0, "Off the little end returns 0");

for (1.5, 2, 2.5, 3, 3.5, 4, 5.5, 6) -> $x
{
    my $i = UpperBound(@array, $x);
    ok(@array[$i - 1] <= $x < @array[$i], "upper bound - 1 <= $x < upper bound");
}

is(LowerBound(@array, 8), @array.elems - 1, "Equal to the big end returns max_index");
is(LowerBound(@array, 8.5), @array.elems, "Off the big end returns max_index + 1");

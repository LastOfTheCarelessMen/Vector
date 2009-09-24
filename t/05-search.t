use v6;
use BinarySearch;
use Test;

plan *;

my @array = (1, 2, 2, 3, 4, 5, 5, 5, 5, 6, 7, 8);

say [<=] @array;
ok([<=] @array, "\@array is sorted properly");

for (0.5, 1.5, 2, 2.5, 3, 3.5, 4, 5.5, 6, 8) -> $x
{
    my $i = LowerBound(@array, $x);
    ok(@array[$i - 1] < $x <= @array[$i], "lower bound < $x <= lower bound + 1");
}

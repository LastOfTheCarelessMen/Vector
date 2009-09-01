use v6;
# use KnotVector;
use Test;

plan *;

sub index:<0/>($a, $b)
{
    return 0 if abs($b) < 1e-10;
    return $a / $b;
}

sub N(@u, $i, $p where { $p == 0 }, $u)
{
    if @u[$i] <= $u <= @u[$i + 1]
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

sub N(@u, $i, $p, $u)
{
    ($u - @u[$i]) 0/ (@u[$i + $p] - @u[$i]) * N(@u, $i, $p - 1, $u)
    + (@u[$i + $p + 1] - $u) 0/ (@u[$i + $p + 1] - @u[$i + 1]) * N(@u, $i + 1, $p - 1, $u);
}


done_testing;
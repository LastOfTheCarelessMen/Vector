use v6;
# use KnotVector;
use Test;

plan *;

sub infix:<O/>($a, $b)
{
    return 0 if abs($b) < 1e-10;
    return $a / $b;
}

multi sub N(@u, $i, $p where { $p == 0 }, $u)
{
    if @u[$i] <= $u < @u[$i + 1]
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

multi sub N(@u, $i, $p, $u)
{
    (($u - @u[$i]) O/ (@u[$i + $p] - @u[$i])) * N(@u, $i, $p - 1, $u)
    + ((@u[$i + $p + 1] - $u) O/ (@u[$i + $p + 1] - @u[$i + 1])) * N(@u, $i + 1, $p - 1, $u);
}

multi sub RangeOfSize($a, $b, $size)
{
    my $delta = ($b - $a) / ($size - 1);
    my $value = $a; 
    return gather
    {
        loop (my $i = 0; $i + 1 < $size; $i++)
        {
            my $result = $value;
            take $result;
            $value += $delta;
        }
        take $b;
    }
}

my @knots = (0, 0, 1, 1);
is_approx(N(@knots, 0, 0, -1), 0, "Before first knot is 0");
is_approx(N(@knots, 0, 0, 0), 0, "At first knot is 0");
is_approx(N(@knots, 0, 0, .25), 0, "Between knots is 0");
is_approx(N(@knots, 0, 0, 1), 0, "At last knot is 0");
is_approx(N(@knots, 0, 0, 2), 0, "After last knot is 0");

is_approx(N(@knots, 1, 0, -1), 0, "Before first knot is 0");
is_approx(N(@knots, 1, 0, 0), 1, "At first knot is 1");
is_approx(N(@knots, 1, 0, .25), 1, "Between knots is 1");
is_approx(N(@knots, 1, 0, 1), 0, "At last knot is 0");
is_approx(N(@knots, 1, 0, 2), 0, "After last knot is 0");

is_approx(N(@knots, 2, 0, -1), 0, "Before first knot is 0");
is_approx(N(@knots, 2, 0, 0), 0, "At first knot is 0");
is_approx(N(@knots, 2, 0, .25), 0, "Between knots is 0");
is_approx(N(@knots, 2, 0, 1), 0, "At last knot is 0");
is_approx(N(@knots, 2, 0, 2), 0, "After last knot is 0");

is_approx(N(@knots, 0, 1, -1), 0, "Before first knot is 0");
is_approx(N(@knots, 1, 1, -1), 0, "Before first knot is 0");
for RangeOfSize(0.0, 0.9999, 10) -> $u
{
    is_approx(N(@knots, 0, 1, $u), 1 - $u, "N_0_1($u) is {1 - $u}");
    is_approx(N(@knots, 1, 1, $u), $u, "N_1_1($u) is $u got {N(@knots, 1, 1, $u)}");
}

done_testing;
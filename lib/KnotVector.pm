use v6;

enum KnotBasisDirection <Left Right>;

sub infix:<O/>($a, $b)
{
    return 0 if abs($b) < 1e-10;
    return $a / $b;
}

class KnotVector
{
    has @.knots;
    
    multi method new (@u) 
    {
        self.bless(*, knots => @u);
    }
    
    multi method N(Int $p where { $p == 0 }, $u, KnotBasisDirection $direction = Left)
    {
        my $impluse_function;
        given $direction
        {
            when Left { $impluse_function = { @.knots[$_] <= $u < @.knots[$_ + 1] ?? 1 !! 0; }; }
            when Right { $impluse_function = { @.knots[$_] < $u <= @.knots[$_ + 1] ?? 1 !! 0; }; }
        }
        return (0..(@.knots.end - 1)).map($impluse_function);
    }
    
    # multi method N(Int $p, $u, KnotBasisDirection $direction = Left)
    # {
    #     my @N_prev = N($p - 1, $u, $direction);
    #     my @knots_without_end = @.knots.delete((@.knots.elems - $p)..@.knots.end);
    #     ($u <<-<< @knots_without_end) 
    #         >>O/<< ((@.knots.delete(0..($p - 1))) >>-<< @knots_without_end)
    # }
}
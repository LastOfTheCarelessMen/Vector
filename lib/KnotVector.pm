use v6;

enum KnotBasisDirection <Left Right>;

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
        return (0..@.knots.end).map($impluse_function);
    }
}
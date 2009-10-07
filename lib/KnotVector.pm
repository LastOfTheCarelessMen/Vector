use v6;
use BinarySearch;

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
    
    our Str multi method Str() 
    {
        "(" ~ @.knots.join(', ') ~ ")";
    }
    
    our Str multi method perl()
    {
        self.WHAT.perl ~ ".new((" ~ @.knots.map({.perl}).join(', ') ~ "))";        
    }
        
    multi method N0_index($u, KnotBasisDirection $direction = Left)
    {
        given $direction
        {
            when Left { LowerBound(@.knots, $u); }
            when Right { UpperBound(@.knots, $u); }
        }
    }
    
    multi method N_local(Int $n0, Int $p, $u, KnotBasisDirection $direction = Left)
    {
        my @N_prev = 0 xx $p, 1, 0;
        my @N = 0 xx ($p + 2);
        
        my $n0p = $n0 - $p - 1;
        
        for 1..$p -> $q
        {
            for ($p - $q)...($p) -> $i
            {
                @N[$i] = (($u - @.knots[$n0p + $i]) O/ (@.knots[$n0p + $i + $q] - @.knots[$n0p + $i])) * @N_prev[$i]
                + ((@.knots[$n0p + $i + $q + 1] - $u) O/ (@.knots[$n0p + $i + $q + 1] - @.knots[$n0p + $i + 1])) * @N_prev[$i + 1];
            }
            @N_prev = @N;
        }
        @N.pop;

        return @N;
    }
    
    multi method N(Int $p, $u, KnotBasisDirection $direction = Left)
    {
        my $n0 = self.N0_index($u, $direction);
        my @N = 0 xx (@.knots.elems - $p - 1);
        @N[($n0-$p-1)..($n0-1)] = self.N_local($n0, $p, $u, $direction);
        return @N;
    }
}
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
    
    multi method N(Int $p, $u, KnotBasisDirection $direction = Left)
    {
        my @N_prev = self.N($p - 1, $u, $direction);
        my $end = @.knots.end;

        # return
        # (
        #     (
        #                              ($u «-« @.knots[0..($end - $p - 1)])
        #                                  »/«
        #         (@.knots[$p..($end - 1)] »-« @.knots[0..($end - $p - 1)]).map({abs($_) < 1e-10 ?? 1.0 !! $_})
        #     )
        #     »*« 
        #     @N_prev[0..(@N_prev.end - 1)]
        # )
        # »+«
        # (
        #     (
        #         (@.knots[($p + 1)..$end] »-» $u)
        #                                  »/«
        #         (@.knots[($p + 1)..$end] »-« @.knots[1..($end - $p)]).map({abs($_) < 1e-10 ?? 1.0 !! $_})
        #     )
        #     »*« 
        #     @N_prev[1..(@N_prev.end)]
        # );

        my @left = (
            (
                                     ($u <<-<< @.knots[0..($end - $p - 1)])
                                         »/«
                (@.knots[$p..($end - 1)] »-« @.knots[0..($end - $p - 1)]).map({abs($_) < 1e-10 ?? 1.0 !! $_})
            ) 
            »*«
            @N_prev[0..(@N_prev.end - 1)]
        );

        my @right1a = @.knots[($p + 1)..$end] >>->> $u;
        my @right1b = @.knots[($p + 1)..$end] »-« @.knots[1..($end - $p)];
        my @right1 = gather for @right1a Z @right1b -> $a, $b { take $a O/ $b; };
        my @right = @right1 »*« @N_prev[1..(@N_prev.end)];
        return @left »+« @right;
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
    
    multi method Nnew(Int $p, $u, KnotBasisDirection $direction = Left)
    {
        my $n0 = self.N0_index($u, $direction);
        my @N = 0 xx (@.knots.elems - $p - 1);
        @N[($n0-$p-1)..($n0-1)] = self.N_local($n0, $p, $u, $direction);
        return @N;
    }
}
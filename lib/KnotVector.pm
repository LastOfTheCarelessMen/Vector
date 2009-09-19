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
    
    multi method N(Int $p, $u, KnotBasisDirection $direction = Left)
    {
        my @N_prev = self.N($p - 1, $u, $direction);
        my $end = @.knots.end;
                
        # return 
        # (
        #     (
        #                              ($u «-« @.knots[0..($end - $p - 1)]) 
        #                                  »O/« 
        #         (@.knots[$p..($end - 1)] »-« @.knots[0..($end - $p - 1)])
        #     ) 
        #     »*« 
        #     @N_prev[0..(@N_prev.end - 1)]
        # )
        # »+«
        # (
        #     (
        #         (@.knots[($p + 1)..$end] »-» $u) 
        #                                  »O/« 
        #         (@.knots[($p + 1)..$end] »-« @.knots[1..($end - $p)])
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
}
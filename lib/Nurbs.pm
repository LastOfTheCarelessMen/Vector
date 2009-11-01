use v6;
use KnotVector;
use Vector;

class Nubs
{
    has $.degree;
    has $.knot_vector;
    has @.control_points;
    
    multi method new(Int $degree, KnotVector $kv, @control_points) 
    {
        self.bless(*, degree => $degree, knot_vector => $kv, control_points => @control_points);
    }
    
    our Str multi method perl()
    {
        self.WHAT.perl ~ ".new($.degree, {$.knot_vector.perl}, {@.control_points.perl})";        
    }
    
    multi method ParameterRange()
    {
        $.knot_vector.ParameterRange($.degree);
    }
    
    # make this next one private?
    multi method Direction($t, KnotBasisDirection $direction)
    {
        return $t < ([+] self.ParameterRange) / 2 ?? Left !! Right if ($direction == Reasonable);
        return $direction;
    }

    multi method evaluate($t, KnotBasisDirection $direction = Reasonable)
    {
        my $n0 = $.knot_vector.N0_index($.degree, $t, self.Direction($t, $direction));
        return [+] ($.knot_vector.N_local($n0, $.degree, $t) 
                    >>*<< @.control_points[$n0 .. ($n0 + $.degree)]);
    }
    
    multi method evaluate($base_t, $actual_t, KnotBasisDirection $direction = Reasonable)
    {
        my $n0 = $.knot_vector.N0_index($.degree, $base_t, self.Direction($base_t, $direction));
        return [+] ($.knot_vector.N_local($n0, $.degree, $actual_t) 
                    >>*<< @.control_points[$n0 .. ($n0 + $.degree)]);
    }
}
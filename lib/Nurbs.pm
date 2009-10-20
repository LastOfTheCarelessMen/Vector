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
    
    multi method Evaluate($t)
    {
        my $n0 = $.knot_vector.N0_index($.degree, $t);
        return [+] ($.knot_vector.N_local($n0, $.degree, $t) 
                    >>*<< @.control_points[$n0 .. ($n0 + $.degree)]);
    }
    
    multi method Evaluate($base_t, $actual_t)
    {
        my $n0 = $.knot_vector.N0_index($.degree, $base_t);
        return [+] ($.knot_vector.N_local($n0, $.degree, $actual_t) 
                    >>*<< @.control_points[$n0 .. ($n0 + $.degree)]);
    }
}
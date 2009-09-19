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
    
    method Evaluate($t)
    {
        my @N = $.knot_vector.N($.degree, $t);
        return [+] (@N >>*<< @.control_points);
    }
}
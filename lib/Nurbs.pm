use v6;
use KnotVector;
use Vector;
use Polynomial;

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
        my @N = $.knot_vector.N($.degree, $t);
        return [+] (@N >>*<< @.control_points);
    }
    
    # multi method Evaluate($t)
    # {
    #     say "Nubs.Evaluate";
    #     my $n0 = $.knot_vector.N0_index($t);
    #     say $n0;
    #     say $.knot_vector.N(1, $t).perl;
    #     say ($.knot_vector.N_local($n0, $.degree, $t)).perl;
    #     say (@.control_points[($n0 - ($.degree + 1)) .. ($n0 - 1)]).perl;
    #     return [+] ($.knot_vector.N_local($n0, $.degree, $t) 
    #                 >>*<< @.control_points[($n0 - ($.degree + 1)) .. ($n0 - 1)]);
    # }
    
    
    multi method MakePolynomial($t)
    {
        my $n0 = $.knot_vector.N0_index($.degree, $t);
        return [+] ($.knot_vector.N_local($n0, $.degree, Polynomial.new(0, 1)) 
                    >>*<< @.control_points[$n0 .. ($n0 + $.degree)]);
    }
}
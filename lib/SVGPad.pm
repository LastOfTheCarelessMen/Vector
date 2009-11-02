use v6;

use Vector;

subset Vector2 of Vector where { $^v.Dim == 2 };

class SVGPad
{
    has Vector2 $.xy_min;
    has Vector2 $.xy_max;
    has Vector2 $.mn_min;
    has Vector2 $.mn_max;
    
    multi method new(Vector2 $xy_min, Vector2 $xy_max, Vector2 $mn_min, Vector2 $mn_max) 
    {
        self.bless(*, xy_min => $xy_min, xy_max => $xy_max, mn_min => $mn_min, mn_max => $mn_max);
    }
    
    multi method xy2mn(Vector2 $xy)
    {
        my $t = ($xy - $.xy_min).coordinates >>/<<  ($.xy_max - $.xy_min).coordinates;
        return $.mn_min + Vector.new(($.mn_max - $.mn_min).coordinates >>*<< $t);
    }
}
use v6;

use Vector;

class SVGPad
{
    has Vector $.xy_min;
    has Vector $.xy_max;
    has Vector $.mn_min;
    has Vector $.mn_max;
    
    multi method new(Vector $xy_min where { $xy_min.Dim == 2 }, 
                     Vector $xy_max where { $xy_max.Dim == 2 }, 
                     Vector $mn_min where { $mn_min.Dim == 2 }, 
                     Vector $mn_max where { $mn_max.Dim == 2 }) 
    {
        self.bless(*, xy_min => $xy_min, xy_max => $xy_max, mn_min => $mn_min, mn_max => $mn_max);
    }
    
    multi method xy2mn(Vector $xy where { $xy.Dim == 2 })
    {
        
        
    }
}
use v6;

class Vector
{
    has @.coordinates;
    
    multi method new (*@x) 
    {
        self.bless(*, coordinates => @x);
    }
    
    multi method new (@x) 
    {
        self.bless(*, coordinates => @x);
    }
    
    our Str multi method Str() 
    {
        "(" ~ @.coordinates.join(', ') ~ ")";
    }
    
    our Str multi method perl()
    {
        "Vector.new(" ~ @.coordinates.map({.perl}).join(', ') ~ ")";        
    }
    
    method Dim()
    {
        @.coordinates.elems;
    }
    
    method Length()
    {
        sqrt [+] (@.coordinates »*« @.coordinates);
    }
    
    method Unitize()
    {
        my $length = self.Length;
        if $length > 1e-10
        {
            return Vector.new(@.coordinates >>/>> $length);
        }
        else
        {
            return Vector.new(@.coordinates);
        }
    }
}

# SHOULD: change this back to normal + when Rakudo supports that
multi sub infix:<⊕>(Vector $a, Vector $b where { $a.Dim == $b.Dim })
{
    Vector.new($a.coordinates »+« $b.coordinates);
}

# SHOULD: change this back to normal - when Rakudo supports that
multi sub infix:<∇>(Vector $a, Vector $b where { $a.Dim == $b.Dim })
{
    Vector.new($a.coordinates »-« $b.coordinates);
}

# SHOULD: change this back to normal - when Rakudo supports that
multi sub prefix:<∇>(Vector $a)
{
    Vector.new(0 <<-<< $a.coordinates);
}

# SHOULD: Scalar * Vector operator - when Rakudo supports
# SHOULD: Vector / Scalar operator - when Rakudo supports

multi sub infix:<⋅>(Vector $a, Vector $b where { $a.Dim == $b.Dim }) # is tighter(&infix:<+>) (NYI)
{
    [+]($a.coordinates »*« $b.coordinates);
}

multi sub infix:<dot>(Vector $a, Vector $b)
{
    $a ⋅ $b;
}

multi sub infix:<×>(Vector $a where { $a.Dim == 3 }, Vector $b where { $b.Dim == 3 })
{
    Vector.new($a.coordinates[1] * $b.coordinates[2] - $a.coordinates[2] * $b.coordinates[1], 
               $a.coordinates[2] * $b.coordinates[0] - $a.coordinates[0] * $b.coordinates[2], 
               $a.coordinates[0] * $b.coordinates[1] - $a.coordinates[1] * $b.coordinates[0]);
}

multi sub infix:<×>(Vector $a where { $a.Dim == 7 }, Vector $b where { $b.Dim == 7 })
{
    Vector.new($a.coordinates[1] * $b.coordinates[3] - $a.coordinates[3] * $b.coordinates[1] 
               + $a.coordinates[2] * $b.coordinates[6] - $a.coordinates[6] * $b.coordinates[2] 
               + $a.coordinates[4] * $b.coordinates[5] - $a.coordinates[5] * $b.coordinates[4],
               $a.coordinates[2] * $b.coordinates[4] - $a.coordinates[4] * $b.coordinates[2] 
               + $a.coordinates[3] * $b.coordinates[0] - $a.coordinates[0] * $b.coordinates[3] 
               + $a.coordinates[5] * $b.coordinates[6] - $a.coordinates[6] * $b.coordinates[5],
               $a.coordinates[3] * $b.coordinates[5] - $a.coordinates[5] * $b.coordinates[3] 
               + $a.coordinates[4] * $b.coordinates[1] - $a.coordinates[1] * $b.coordinates[4] 
               + $a.coordinates[6] * $b.coordinates[0] - $a.coordinates[0] * $b.coordinates[6],
               $a.coordinates[4] * $b.coordinates[6] - $a.coordinates[6] * $b.coordinates[4] 
               + $a.coordinates[5] * $b.coordinates[2] - $a.coordinates[2] * $b.coordinates[5] 
               + $a.coordinates[0] * $b.coordinates[1] - $a.coordinates[1] * $b.coordinates[0],
               $a.coordinates[5] * $b.coordinates[0] - $a.coordinates[0] * $b.coordinates[5] 
               + $a.coordinates[6] * $b.coordinates[3] - $a.coordinates[3] * $b.coordinates[6] 
               + $a.coordinates[1] * $b.coordinates[2] - $a.coordinates[2] * $b.coordinates[1],
               $a.coordinates[6] * $b.coordinates[1] - $a.coordinates[1] * $b.coordinates[6] 
               + $a.coordinates[0] * $b.coordinates[4] - $a.coordinates[4] * $b.coordinates[0] 
               + $a.coordinates[2] * $b.coordinates[3] - $a.coordinates[3] * $b.coordinates[2],
               $a.coordinates[0] * $b.coordinates[2] - $a.coordinates[2] * $b.coordinates[0] 
               + $a.coordinates[1] * $b.coordinates[5] - $a.coordinates[5] * $b.coordinates[1] 
               + $a.coordinates[3] * $b.coordinates[4] - $a.coordinates[4] * $b.coordinates[3]);
}

multi sub infix:<cross>(Vector $a, Vector $b)
{
    $a × $b;
}

multi sub circumfix:<⎡ ⎤>(Vector $a)
{
    $a.Length;
}

subset UnitVector of Vector where { (1 - 1e-10) < $^v.Length < (1 + 1e-10) };


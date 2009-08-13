use v6;

class Vector
{
    has $.coordinates;
    
    multi method new ($self: $x, $y, $z) 
    {
  	    $self.bless(*, coordinates => ($x, $y, $z));
  	}
  	
  	multi method new ($self: @x) 
    {
  	    $self.bless(*, coordinates => @x);
  	}
    
    our Str multi method Str() 
    {
        "(" ~ $.coordinates.join(', ') ~ ")";
    }
    
    method Dim()
    {
        $.coordinates.elems;
    }
    
    method LengthSquared()
    {
        [+] ($.coordinates <<*>> $.coordinates); 
    }
    
    method Length()
    {
        self.LengthSquared.sqrt;
    }
    
    method Unitize()
    {
        my $length = self.Length;
        if $length.abs > 1e-10
        {
            return Vector.new($.coordinates >>/>> $length);
        }
        else
        {
            return Vector.new($.coordinates);
        }
    }
}

# SHOULD: change this back to normal + when Rakudo supports that
multi sub infix:<⊕>(Vector $a, Vector $b)
{
    Vector.new($a.coordinates «+» $b.coordinates);
}

# SHOULD: change this back to normal - when Rakudo supports that
multi sub infix:<∇>(Vector $a, Vector $b)
{
    Vector.new($a.coordinates «-» $b.coordinates);
}

# SHOULD: change this back to normal - when Rakudo supports that
multi sub prefix:<∇>(Vector $a)
{
    Vector.new(0 <<-<< $a.coordinates);
}

# SHOULD: Scalar * Vector operator - when Rakudo supports
# SHOULD: Vector / Scalar operator - when Rakudo supports

multi sub infix:<⋅>(Vector $a, Vector $b)
{
    [+]($a.coordinates «*» $b.coordinates);
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

multi sub infix:<cross>(Vector $a, Vector $b)
{
    $a × $b;
}

multi sub circumfix:<⎡ ⎤>(Vector $a)
{
    $a.Length;
}

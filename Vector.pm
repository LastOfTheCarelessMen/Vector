use v6;

class Vector
{
    has $.coordinates;
    
    multi method new ($self: Num $x, Num $y, Num $z) 
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

sub infix:<⋅>(Vector $a, Vector $b)
{
    [+]($a.coordinates «*» $b.coordinates);
}

sub infix:<×>(Vector $a, Vector $b)
{
    Vector.new($a.coordinates[1] * $b.coordinates[2] - $a.coordinates[2] * $b.coordinates[1], 
               $a.coordinates[2] * $b.coordinates[0] - $a.coordinates[0] * $b.coordinates[2], 
               $a.coordinates[0] * $b.coordinates[1] - $a.coordinates[1] * $b.coordinates[0]);
}

use v6;

class Polynomial
{
    has @.coefficients;
    
    multi method new (*@x) 
    {
        if (@x.elems == 0)
        {
            self.bless(*, coefficients => 0);
        }
        else
        {
            self.bless(*, coefficients => @x);
        }
    }
    
    multi method new (@x) 
    {
        if (@x.elems == 0)
        {
            self.bless(*, coefficients => 0);
        }
        else
        {
            self.bless(*, coefficients => @x);
        }
    }
    
    our Str multi method Str() 
    {
       (^(@.coefficients.elems)).map({"{@.coefficients[$_]} x^$_"}).reverse.join(" + ");
        # (^3).map({"{@.coefficients[$_]} x^$_"}).reverse.join(" + ");
    }
    
    our Str multi method perl()
    {
        self.WHAT.perl ~ ".new(" ~ @.coefficients.map({.perl}).join(', ') ~ ")";        
    }
    
    our multi method evaluate($x)
    {
        [+] ((^(@.coefficients.elems)).map({@.coefficients[$_] * ($x ** $_)}));
    }
}

multi sub infix:<+>(Polynomial $a, Polynomial $b)
{
    my $length = ($a.coefficients.elems, $b.coefficients.elems).max;
    my @ac = $a.coefficients;
    @ac.push: (0 xx ($length - @ac.elems));
    my @bc = $b.coefficients;
    @bc.push: (0 xx ($length - @bc.elems));
    return Polynomial.new(@ac »+« @bc);
}

multi sub infix:<+>(Polynomial $a, $b)
{
    my @ac = $a.coefficients;
    @ac[0] += $b;
    return Polynomial.new(@ac);
}

multi sub infix:<+>($b, Polynomial $a)
{
    $a + $b;
}

multi sub prefix:<->(Polynomial $a)
{
    Polynomial.new(0 <<-<< $a.coefficients);
}

multi sub infix:<->(Polynomial $a, Polynomial $b)
{
    -$b + $a;
}

multi sub infix:<->(Polynomial $a, $b)
{
    my @ac = $a.coefficients;
    @ac[0] -= $b;
    return Polynomial.new(@ac);
}

multi sub infix:<->($b, Polynomial $a)
{
    -$a + $b;
}

multi sub infix:<*>(Polynomial $a, Polynomial $b)
{
    my @coef = 0.0 xx ($a.coefficients.elems + $b.coefficients.elems - 1);
    for ^($a.coefficients.elems) -> $m
    {
        for ^($b.coefficients.elems) -> $n
        {
            @coef[$m + $n] += $a.coefficients[$m] * $b.coefficients[$n];
        }
    }
    
    return Polynomial.new(@coef);
}

multi sub infix:<*>(Polynomial $a, $b)
{
    Polynomial.new($a.coefficients >>*>> $b);
}

multi sub infix:<*>($b, Polynomial $a)
{
    Polynomial.new($a.coefficients >>*>> $b);
}

multi sub infix:</>(Polynomial $a, $b)
{
    Polynomial.new($a.coefficients >>/>> $b);
}
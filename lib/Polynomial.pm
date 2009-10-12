use v6;

class Polynomial
{
    has @.coefficients;
    
    multi method new (*@x is copy) 
    {
        while @x.elems > 1 && @x[*-1].abs < 1e-13
        {
            say @x.perl;
            say @x[*-1];
            @x.pop;
        }
        
        if (@x.elems == 0)
        {
            self.bless(*, coefficients => 0);
        }
        else
        {
            self.bless(*, coefficients => @x);
        }
    }
    
    multi method new (@x is copy) 
    {
        while @x.elems > 1 && @x[*-1].abs < 1e-13
        {
            # say @x.perl;
            # say @x[*-1];
            @x.pop;
        }
        
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
    my $lct = 0;
    my @leftover = ();
    given $a.coefficients.elems <=> $b.coefficients.elems
    {
        when -1 { $lct = $a.coefficients.elems - 1; @leftover = $b.coefficients[($lct+1)..(*-1)]; }
        when +1 { $lct = $b.coefficients.elems - 1; @leftover = $a.coefficients[($lct+1)..(*-1)]; }
        when 0 { $lct = $b.coefficients.elems - 1; }
    }
    # say "a: {$a.coefficients}";
    # say "b: {$b.coefficients}";
    # say "c: {$a.coefficients[0..$lct].perl}";
    # say "d: {$b.coefficients[0..$lct].perl}";
    # say "e: {@leftover.perl}";
    return Polynomial.new($a.coefficients[0..$lct] >>+<< $b.coefficients[0..$lct], @leftover);
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

multi sub infix:<*>(Polynomial $a, $b) is default
{
    Polynomial.new($a.coefficients >>*>> $b);
}

multi sub infix:<*>($b, Polynomial $a) is default
{
    Polynomial.new($a.coefficients >>*>> $b);
}

multi sub infix:</>(Polynomial $a, $b)
{
    Polynomial.new($a.coefficients >>/>> $b);
}
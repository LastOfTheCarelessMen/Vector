use v6;
use Polynomial;
use Test;

plan *;

my $p = Polynomial.new(1.0, 2.0, 3.0);
my $p2 = Polynomial.new(0.0, 0.0, 3.0, 5.0, 6.0);
my $p3 = Polynomial.new();
my $p4 = Polynomial.new(1.0);
my $p5 = Polynomial.new(0, 0, 3, 5, 6, 0.0, 0);

isa_ok($p, Polynomial, "Variable is of type Polynomial");
isa_ok($p2, Polynomial, "Variable is of type Polynomial");
isa_ok($p3, Polynomial, "Variable is of type Polynomial");
isa_ok($p4, Polynomial, "Variable is of type Polynomial");
isa_ok($p5, Polynomial, "Variable is of type Polynomial");

is(~$p3, "0 x^0", "Empty Polynomial.new generates constant 0");
is(~$p, "3 x^2 + 2 x^1 + 1 x^0", "Polynomial.Str works correctly");
is(~eval($p.perl), ~$p, ".perl works, tested with Str");
isa_ok(eval($p.perl), Polynomial, ".perl works, tested with isa");

is($p5.coefficients.elems, 5, "Leading zero coefficients deleted");

is_approx($p.evaluate(0.0), 1.0, "\$p.evaluate(0.0) == 1");
is_approx($p.evaluate(1.0), 6.0, "\$p.evaluate(1.0) == 6");

my $sum = $p + -$p;
is($sum.coefficients.elems, 1, "p + (-p) has only one coefficient");
is_approx($sum.coefficients[0], 0, "p + (-p) has only one coefficient == 0");

$sum = $p + $p2;
for ^10 -> $x
{
    is_approx($sum.evaluate($x), $p.evaluate($x) + $p2.evaluate($x), "sum = p + p2 for $x");
}

$sum += 3;
for ^10 -> $x
{
    is_approx($sum.evaluate($x), $p.evaluate($x) + $p2.evaluate($x) + 3, "sum + 3 = p + p2 + 3 for $x");
}

$sum = 5 + $sum;
for ^10 -> $x
{
    is_approx($sum.evaluate($x), $p.evaluate($x) + $p2.evaluate($x) + 8, "5 + (sum + 3) = p + p2 + 8 for $x");
}

$sum = -$sum;
for ^10 -> $x
{
    is_approx($sum.evaluate($x), -($p.evaluate($x) + $p2.evaluate($x) + 8), "-(5 + (sum + 3)) = -(p + p2 + 8) for $x");
}

my $product = $sum * $p4;
for ^10 -> $x
{
    is_approx($product.evaluate($x), $sum.evaluate($x), "sum * (1 x^0) = sum for $x");
}

$product = $sum * $p3;
for ^10 -> $x
{
    is_approx($product.evaluate($x), 0.0, "sum * (0 x^0) = 0 for $x");
}

$product = $sum * 1;
for ^10 -> $x
{
    is_approx($product.evaluate($x), $sum.evaluate($x), "sum * 1 = sum for $x");
}

$product = $sum * 0;
for ^10 -> $x
{
    is_approx($product.evaluate($x), 0.0, "sum * 0 = 0 for $x");
}

$product = 2.5 * $sum;
for ^10 -> $x
{
    is_approx($product.evaluate($x), 2.5 * $sum.evaluate($x), "sum * 2.5 = sum * 2.5 for $x");
}

$product = 1 * $sum;
for ^10 -> $x
{
    is_approx($product.evaluate($x), $sum.evaluate($x), "sum * 1 = sum for $x");
}

$product = 0 * $sum;
for ^10 -> $x
{
    is_approx($product.evaluate($x), 0.0, "sum * 0 = 0 for $x");
}

$product = $p * $p2;
for ^10 -> $x
{
    is_approx($product.evaluate($x), $p.evaluate($x) * $p2.evaluate($x), "product = p * p2 for $x");
}

$product /= 5.5;
for ^10 -> $x
{
    is_approx($product.evaluate($x), $p.evaluate($x) * $p2.evaluate($x) / 5.5, "product / 5.5 = p * p2 / 5.5 for $x");
}

done_testing;

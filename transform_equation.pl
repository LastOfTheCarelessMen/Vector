use v6;

for $*IN.lines() -> $text
{
    say $text.subst(/x_(\d) y_(\d)/, { "\$a.coordinates[{$0 - 1}] * \$b.coordinates[{$1 - 1}]" }, :g);
}
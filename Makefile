PERL6=/Users/colomon/tools/rakudo/perl6
RAKUDO_DIR=/Users/colomon/tools/rakudo
PERL6LIB='/Users/colomon/tools/rakudo/:lib:/Users/colomon/LastOfTheCarelessMen/Vector/lib:$(RAKUDO_DIR)'

SOURCES=lib/Vector.pm lib/KnotVector.pm lib/Nurbs.pm

PIRS=$(SOURCES:.pm=.pir)

all: $(PIRS)

%.pir: %.pm
	env PERL6LIB=$(PERL6LIB) $(PERL6) --target=pir --output=$@ $<

clean:
	rm -f $(PIRS)

test: all
	env PERL6LIB=$(PERL6LIB) prove -e '$(PERL6)' -r --nocolor t/

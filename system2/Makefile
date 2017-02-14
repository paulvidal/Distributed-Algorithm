.SUFFIXES: .erl .beam

MODULES  = system2 app process pl

# BUILD =======================================================

ERLC	= erlc -o ebin

ebin/%.beam: %.erl
	$(ERLC) $<

all:	ebin ${MODULES:%=ebin/%.beam}

ebin:
	mkdir ebin

.PHONY: clean
clean:
	rm -f ebin/* erl_crash.dump

# RUN =========================================================

SYSTEM    = system2
L_ERL      = erl -noshell -pa ebin -setcookie pass

run1: all
	$(L_ERL) -s $(SYSTEM) start 100 1000

run2: all
	$(L_ERL) -s $(SYSTEM) start 0 1000

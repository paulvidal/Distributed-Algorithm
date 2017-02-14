.SUFFIXES: .erl .beam

MODULES  = system4 app process pl best_effort_broadcast

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

SYSTEM     = system4
L_ERL      = erl -noshell -pa ebin -setcookie pass

run1: all
	$(L_ERL) -s $(SYSTEM) start 100 1000

run2: all
	$(L_ERL) -s $(SYSTEM) start 0 1000

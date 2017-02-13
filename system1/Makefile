.SUFFIXES: .erl .beam

MODULES  = system1 process

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

SYSTEM1    = system1
L_ERL      = erl -noshell -pa ebin -setcookie pass

run1: all
	$(L_ERL) -s $(SYSTEM1) start 1000 3000

run2: all
	$(L_ERL) -s $(SYSTEM1) start 0 3000

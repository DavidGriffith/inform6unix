## Automake template for Inform documentation.

infodir = $(prefix)/info

MANUAL = inform inform.01 inform.02 inform.03 inform.04 inform.05 inform.06 \
inform.07 inform.08 inform.09 inform.10 inform.11 inform.12 inform.13	    \
inform.14 inform.15 inform.16

CRAFT = craft.info

TUTOR = inftutor.info

info_DATA = $(MANUAL) $(CRAFT) $(TUTOR)

EXTRA_DIST = $(info_DATA)

INFOIZE = infoize

INFFILES = craft.inf inftutor.inf

doc:;	@ for file in $(INFFILES); do \
		base=`basename $$file .inf`; \
		cmd="$(INFOIZE) -i $$base -o $$base.info $$file"; \
		echo $$cmd; $$cmd; \
	done

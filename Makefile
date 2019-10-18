################################################################################
##                                                                       GENERAL
################################################################################

PROJECT = note

PWD        = ${shell pwd}
TEX_INPUT  = ${PWD}/tex
TIKZ_INPUT = ${PWD}/tikz
BUILD      = ${PWD}/build


LATEX_CMD   = pdflatex
LATEX_FLAGS = -shell-escape -halt-on-error -file-line-error -output-directory ${BUILD}
TEX_FILES   = $(shell find ${TEX_INPUT} -name '*.tex')

TIKZ_CMD   = pdflatex
TIKZ_FLAGS = $(LATEX_FLAGS)
TIKZ_FILES = $(shell find ${TIKZ_INPUT} -name '*.tex')
TIKZ_IMG   = $(TIKZ_FILES:%.tex=%.pdf)

export TEXINPUTS := ${TEX_INPUT}:${TEXINPUTS}

all: ${PROJECT}.pdf

${PROJECT}.pdf: ${BUILD}/$(PROJECT).pdf
	cp $< $(PROJECT).pdf

view: ${PROJECT}.pdf
	(zathura $(PROJECT).pdf &)

tikz: $(TIKZ_IMG)
	@echo "Built TIKZ images"


${BUILD}/$(PROJECT).pdf: ${BUILD}/$(PROJECT).aux
	$(LATEX_CMD) $(LATEX_FLAGS) $(PROJECT)

${BUILD}/$(PROJECT).aux: $(TEX_FILES) $(TIKZ_IMG) | ${BUILD}
	$(LATEX_CMD) $(LATEX_FLAGS) $(PROJECT)

${TIKZ_INPUT}/%.pdf: ${TIKZ_INPUT}/%.tex | ${BUILD}
	@echo "Builing TIKZ image: $@"
	$(TIKZ_CMD) $(TIKZ_FLAGS) $<
	cp ${BUILD}/$*.pdf $@

${BUILD}:
	mkdir -p ${BUILD}


clean:
	rm -rf ${BUILD}
	if [ -f ${PROJECT}.pdf ] ; then rm ${PROJECT}.pdf ; fi;

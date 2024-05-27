
include solver/kissat/BUILD.mk
include solver/yices2/BUILD.mk

solver: \
	o/solver/kissat/built.fat \
	o/solver/yices2/built.fat

.PHONY: solver

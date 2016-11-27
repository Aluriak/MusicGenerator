all: gen playmid

gen:
	python -m generator

playmid:
	timidity output.mid

t: tests
tests:
	pytest generator --doctest-module -v

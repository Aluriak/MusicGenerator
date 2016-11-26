gen:
	python -m generator

t: tests
tests:
	pytest generator --doctest-module -v

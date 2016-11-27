$(PYTHON)=python3


# default recipe
all: DI_notesR playmid


# generation recipes
DI_notesR:
	$(PYTHON) -m generator Matlab/NotesTrouve/notesR.txt DI --midi=output/notesR_generated_by_double_independances.mid
DI_notesRlong:
	$(PYTHON) -m generator Matlab/NotesTrouve/notesRlong.txt DI --midi=output/notesRlong_generated_by_double_independances.mid
DI_rossini_train:
	$(PYTHON) -m generator ./Matlab/NotesTrouve/petit_train_de_plaisr.txt DI --midi=output/rossiniTrain_generated_by_double_independances.mid
DI_rossini_caprice:
	$(PYTHON) -m generator ./Matlab/NotesTrouve/petit_caprice.txt DI --midi=output/rossiniCaprice_generated_by_double_independances.mid


# play music
playmid:
	timidity output/*.mid


# Unit tests
t: tests
tests:
	pytest generator --doctest-module -v

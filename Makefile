PYTHON=python3


# default recipe
all: DI_mendel playmid


# generation recipes
DI_mendel:
	$(PYTHON) -m generator ./Matlab/NotesTrouve/mendel_op19_3.txt DI --midi=output/mendel_generated_by_double_independances.mid --markov-order=7
DI_notesR:
	$(PYTHON) -m generator Matlab/NotesTrouve/notesR.txt DI  --midi=output/notesR_generated_by_double_independances.mid --markov-order=3
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

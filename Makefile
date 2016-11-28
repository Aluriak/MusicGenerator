PYTHON=python3


# default recipe
all: DI_mz playmid

 
# generation recipes
DI_chopin:
	$(PYTHON) -m generator ./AudioRessources/NotesTrouve/chpn_op23.txt DI --midi=output/chpn_op23_generated_by_double_independances.mid --markov-order=6
DI_mz:
	$(PYTHON) -m generator ./AudioRessources/NotesTrouve/mz_332_1.txt DI --midi=output/mz_332_1_generated_by_double_independances.mid --markov-order=6
DI_mendel:
	$(PYTHON) -m generator ./AudioRessources/NotesTrouve/mendel_op19_3.txt DI --midi=output/mendel_generated_by_double_independances.mid --markov-order=6
DI_notesR:
	$(PYTHON) -m generator AudioRessources/NotesTrouve/notesR.txt DI  --midi=output/notesR_generated_by_double_independances.mid --markov-order=3
DI_notesRlong:
	$(PYTHON) -m generator AudioRessources/NotesTrouve/notesRlong.txt DI --midi=output/notesRlong_generated_by_double_independances.mid
DI_rossini_train:
	$(PYTHON) -m generator ./AudioRessources/NotesTrouve/petit_train_de_plaisr.txt DI --midi=output/rossiniTrain_generated_by_double_independances.mid
DI_rossini_caprice:
	$(PYTHON) -m generator ./AudioRessources/NotesTrouve/petit_caprice.txt DI --midi=output/rossiniCaprice_generated_by_double_independances.mid


# play music
playmid:
	timidity output/*.mid


# Unit tests
t: tests
tests:
	pytest generator --doctest-module -v

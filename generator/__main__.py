

import csv
from generator import generator
from generator import classifier
from generator import music_player


INPUT_FILE = './Matlab/NotesTrouve/notesR.txt'
INPUT_FILE = './Matlab/NotesTrouve/notesRlong.txt'
INPUT_DELIM = '\t'


def notes_from_file(filename:str=INPUT_FILE, delimiter:str=INPUT_DELIM) -> iter:
    """Yield pairs (millisecond, note) found in given file.

    Given file should be a DSV file with delimiter `delimiter`,
    and expose two values per lines, millisecond and note.

    """
    with open(filename) as fd:
        yield from ((int(note), int(ms))
                    for ms, note in csv.reader(fd, delimiter=delimiter))


if __name__ == "__main__":
    notes, mss = (zip(*tuple(notes_from_file())))
    print('PLAYING INPUT MUSIC…')
    music_player.play(zip(notes, mss))

    print('PLAYING GENERATED MUSIC…')
    classif = classifier.clusterizer_by(4)
    classif_value = {0: 0.1, 1: 0.2, 2: 0.3, 3: 0.4}
    gen = generator.double_independances(notes, mss, time_classifier=classif,
                                         note_number=10)
    music_player.play(gen, classif_value)

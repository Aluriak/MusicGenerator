"""

usage: generator <input-file> [<method>]['--markov-order'] [--midi=FILE|--timed-play]
                 [--timed-play-input|--play-input] [--markov-order=INT]

exemple:
    python -m generator mymusic.tsv --midi=mymusic.mid

"""


import csv
import docopt
from generator import generator
from generator import classifier
from generator import music_player


INPUT_DELIM = '\t'


def notes_from_file(filename:str, delimiter:str=INPUT_DELIM) -> iter:
    """Yield pairs (millisecond, note) found in given file.

    Given file should be a DSV file with delimiter `delimiter`,
    and expose two values per lines, millisecond and note.

    """
    with open(filename) as fd:
        yield from ((int(note), int(ms))
                    for ms, note in csv.reader(fd, delimiter=delimiter))


if __name__ == "__main__":
    args = docopt.docopt(__doc__)
    markov_order = int(args['--markov-order'] or 3)
    assert markov_order >= 1, "Markov chain order should be >= 1"
    gen_method = generator.get_method(args['<method>'] or 'DI')

    notes, mss = (zip(*tuple(notes_from_file(args['<input-file>']))))
    if args['--play-input'] or args['--timed-play-input']:
        print('PLAYING INPUT MUSIC…')
        player = music_player.play if args['--play-input'] else music_player.timed_play
        player(zip(notes, mss))

    CLASSIF_K, SPEED = 6, 0.07
    classif = classifier.clusterizer_by(CLASSIF_K)
    classif_value = {c: (idx*2)*SPEED for idx, c in enumerate(range(CLASSIF_K), start=1)}
    #gen = gen_method(notes, mss, time_classifier=classif, note_number=100)
    gen = gen_method(notes, mss, time_classifier=classif, note_number=200, 
    note_chain_order=markov_order, time_chain_order=markov_order)
        
    if args['--midi']:
        print('Midi file {} will be overwritten.'.format(args['--midi']))
        music_player.midi_writer(gen, classif_value,
                                 midi_filename=args['--midi'])
    else:
        print('PLAYING GENERATED MUSIC…')
        if args['--timed-play']:
            music_player.play(gen, classif_value)
        else:  # play it without timer
            music_player.timed_play(gen, classif_value)

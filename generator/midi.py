"""Implementations relative to midi format

"""

from io import StringIO
import sys


def write(notes:iter, filename:str='output.mid', bpm:int=120):
    """Write in midi format given notes in given file.

    notes -- iterable of [play time, note code, velocity, duration]
    filename -- will be overwritten
    bpm -- beat per second

    """
    from miditime.miditime import MIDITime
    writer = MIDITime(bpm, filename)
    writer.add_track(tuple(notes))
    with Capturing() as output:
        writer.save_midi()


class Capturing:
    """This is a stdout capturing, used one time to avoid unecessary output
    from the midi tierce library.

    usage:
        with Capturing() as output:
                do_something(my_object)

    Found at http://stackoverflow.com/a/16571630

    """

    def __enter__(self):
        self._stdout = sys.stdout
        sys.stdout = self._stringio = StringIO()
        return self

    def __exit__(self, *args):
        sys.stdout = self._stdout

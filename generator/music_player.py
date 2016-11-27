"""Implementation of the music player,
able to play a stream of (note, milliseconds).

All players provides the following API:

    stream -- iterable of (note, wait_value)
    time_value -- associate wait_value with seconds to wait for the next note

The second parameter allows client to specify the time in seconds
for clusterized groups of times.
By default, wait_value is assumed to be a time in milliseconds, and is
converted to seconds by dividing it by 1000.

A typical use case is to clusterize times into (0, 1, 2, 3),
and maps for instance 0 with 0.1, 1 with 0.2, 2 with 0.4 and 3 with 0.8.
This way, generated music use up to 4 different waiting times.

"""


import time

from generator import midi
from generator import sound


def default_note_player(note:int, sec:int):
    sound.play_midi(note)
def ms_to_sec(time):
    return time / 1000


def play(stream:iter, time_value:callable or dict=ms_to_sec,
         on_note:callable=default_note_player):
    # get (time value) -> (wait value) function
    time_value_caller = time_value
    if isinstance(time_value, dict):
        time_value_caller = lambda x: time_value[x]
    # play
    current_time = time.time()
    stream = ((note, time_value_caller(ms)) for note, ms in stream)
    for note, sec in stream:
        on_note(note, current_time)
        time.sleep(sec)


def timed_play(stream:iter, time_value:callable or dict=ms_to_sec,
               on_note:callable=default_note_player):
    """Same as play(), but take in account the real time,
    in order to amortize computation cost of the next item of given stream.

    """
    # get (time value) -> (wait value) function
    time_value_caller = time_value
    if isinstance(time_value, dict):
        time_value_caller = lambda x: time_value[x]
    # play
    current_time = time.time()
    wait_time = 0  # first note don't wait
    stream = ((note, time_value_caller(ms)) for note, ms in stream)
    for note, wait_time in stream:
        on_note(note, current_time)
        while time.time() - current_time < wait_time:
            pass
        current_time = time.time()


def midi_writer(stream:iter, time_value:callable or dict=ms_to_sec,
                midi_filename:str='output.mid', bpm:int=120):
    """Same as play(2), but write a midi file instead of playing the sounds"""

    # get (time value) -> (wait value) function
    time_value_caller = time_value
    if isinstance(time_value, dict):
        time_value_caller = lambda x: time_value[x]
    # play
    def gen_notes():
        NOTE_VELOCITY = 120
        NOTE_DURATION = 4
        play_time = 0.
        notes = ((note, time_value_caller(ms)) for note, ms in stream)
        for note, sec in notes:
            yield [play_time, note, NOTE_VELOCITY, NOTE_DURATION]
            play_time += sec

    midi.write(gen_notes(), midi_filename, bpm)

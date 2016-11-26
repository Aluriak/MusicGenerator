"""Implementation of the music player,
able to play a stream of (note, milliseconds).

"""


import time

from generator.sound import play_midi


def play(stream:iter):
    stream = ((note, ms / 1000) for note, ms in stream)
    for note, sec in stream:
        play_midi(note)
        time.sleep(sec)


def timed_play(stream:iter):
    """Same as play(1), but take in account the real time,
    in order to amortize computation cost of the next item of given stream.

    """
    current_time = time.time()
    wait_time = 0  # first note don't wait
    stream = ((note, ms) / 1000 for note, ms in stream)
    for note, sec in stream:
        while time.time() - current < wait_time:
            pass
        play_midi(note)
        wait_time = sec



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

from generator.sound import play_midi

ms_to_sec = lambda t: t / 1000

def play(stream:iter, time_value:callable or dict=ms_to_sec):
    # get (time value) -> (wait value) function
    time_value_caller = time_value
    if isinstance(time_value, dict):
        time_value_caller = lambda x: time_value[x]
    # play
    stream = ((note, time_value_caller(ms)) for note, ms in stream)
    for note, sec in stream:
        play_midi(note)
        time.sleep(sec)


def timed_play(stream:iter, time_value:callable or dict=ms_to_sec):
    """Same as play(1), but take in account the real time,
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
    for note, sec in stream:
        while time.time() - current < wait_time:
            pass
        play_midi(note)
        wait_time = sec



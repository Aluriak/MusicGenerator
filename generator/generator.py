"""Implementations of generators.

A generator is a mapping ([notes], [milliseconds]) -> ((notes, milliseconds),)
which yield notes and associated time knowing two ordered set of notes
and milliseconds, where milliseconds[i] is the time to wait
before the note following note[i] to be played.

Generators can also expose parameters to define either the number of notes
to generate, or the time of the generated composition.

Generators differs by generation implementation.

Generators parameters are the following:

    notes -- iterable of notes
    times -- iterable of milliseconds
    note_number -- maximal number of note to be generated
    time_limit -- maximal time length of the generated composition
    time_classifier -- classifier function for time mappings
    other -- other args, specific to the generation method

if both note_number and time_limit are:
    -  None: generation will go forever
    - ¬None: generation will stop until at least one the limit is met

"""


import itertools
from collections import deque

from generator import markov
from generator import classifier


def double_independances(notes:iter, times:iter, *, note_number:int=None,
                         time_limit:int=None,
                         time_classifier:callable=classifier.clusterizer_by(4),
                         note_chain_order:int=1,
                         time_chain_order:int=1, note_start:iter=None,
                         time_start:iter=None) -> iter:
    """Generation of music by implementing two independant markov chains
    of given order (default 1), starting the markov generation with the given
    starting sequence, or the beginning of given notes and times.

    """
    # get markov starting values
    if not note_start:
        notes, first_notes = itertools.tee(notes)
        note_start = tuple(itertools.islice(first_notes, 0, note_chain_order))
        del first_notes
    if not time_start:
        times, first_times = itertools.tee(times)
        time_start = tuple(itertools.islice(first_times, 0, time_chain_order))
        del first_times
    note_chain = markov.chain(notes, order=note_chain_order)
    time_chain = markov.chain(times, order=time_chain_order)
    note_state = deque(note_start, maxlen=note_chain_order)
    time_state = deque(time_start, maxlen=time_chain_order)
    played_time = 0.
    for step in itertools.count():
        if note_number and step >= note_number:
            return  # note number limit reached
        if time_limit  and played_time > time_limit:
            return  # time limit reached
        # get a new note and a new time
        note = markov.random_walk(note_chain, note_state)
        note_state.append(note)
        time = markov.random_walk(time_chain, time_state)
        time_state.append(time)
        yield note, time
        played_time += time



"""Implementation of various utilitaries"""


import bisect
import itertools
from collections import deque


def sliding(sequence:iter, size:int) -> iter:
    """Yield tuple of `size` elements"""
    sequence = iter(sequence)
    cont = deque(itertools.islice(sequence, 0, size), maxlen=size)
    yield tuple(cont)
    for elem in sequence:
        cont.append(elem)
        yield tuple(cont)


# found at https://docs.python.org/3.5/library/itertools.html
def grouper(iterable, size, fillvalue=None):
    "Collect data into fixed-length chunks or blocks"
    # grouper('ABCDEFG', 3, 'x') --> ABC DEF Gxx"
    args = [iter(iterable)] * size
    return itertools.zip_longest(*args, fillvalue=fillvalue)


def group_level(value, levels:tuple, groups:tuple) -> 'group':
    """Return the group to which given value belongs,
    according to given levels.

    See also https://docs.python.org/3.5/library/bisect.html#other-examples

    """
    assert len(levels) == len(groups) - 1
    return groups[bisect.bisect(levels, value)]

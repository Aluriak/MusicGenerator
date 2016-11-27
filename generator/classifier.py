"""Implementation of time discretizers.

There are useful to discretize times in order to get a finite number
of node in markov models.

"""


import math
import bisect
import itertools
from functools import partial

from generator import utils


def _cluster(level, breakpoints:tuple, groups:tuple):
    """Return the group to which given level belongs.

    See also https://docs.python.org/3.5/library/bisect.html#other-examples

    """
    assert len(breakpoints) == len(groups) - 1
    return groups[bisect.bisect(breakpoints, level)]


def k_clustering(times:tuple, groups:tuple) -> iter:
    """Discretize given times by equally dividing them in len(groups) clusters,
    each associated with one of groups.

    """
    times = tuple(times)
    groups = tuple(groups)
    sorted_times = tuple(sorted(times))
    time_per_group = math.ceil(len(times) / len(groups))
    # bounds is the list of minimal values to be in a group. The first is not given.
    bounds = tuple(values[0] for values in utils.grouper(sorted_times, time_per_group))[1:]
    yield from (_cluster(time, bounds, groups)
                for time in times)


def non_classified(times:tuple) -> tuple:
    """Return the same data, allowing client to keep the same data"""
    return times


def clusterizer_by(n:int) -> callable:
    """Return a function equals to partial k_clustering(2), where groups are
    already provided as n elements.

    """
    return partial(k_clustering, groups=range(n))

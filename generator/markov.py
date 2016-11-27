"""Implementation of the markov chain
as a mapping like {(prev): {succ: likelihood}},

where `succ` have a likelihood `likelihood` to appear when `prev` is found.
Size of the tuple `prev` is named the order of the markov chain.

For instance, a markov chain of order 4 maps the 4 previous elements
with the current one.

Main API provides builder, queriers, and generator.

"""


import random
import itertools
from collections import defaultdict, Counter

from generator import utils


def chain(sequence:iter, order:int) -> dict:
    """Return a mapping {(prev): {succ: likelihood}}"""
    prevs_to_succs = defaultdict(list)
    for *prevs, item in utils.sliding(sequence, size=int(order) + 1):
        prevs_to_succs[tuple(prevs)].append(item)
    # compute likelihood for each succ of each prevs
    ret = {}
    for prevs, succs in prevs_to_succs.items():
        counts = Counter(succs)
        total = sum(counts.values())
        ret[prevs] = { succ: counts[succ] / total for succ in succs }
    return ret




def random_walk(chain:dict, state:tuple, default=None):
    """Return a randomly choosen next object of the given chain.

    If given state is not in chain, then the default value will be returned.

    """
    state = tuple(state)

    succs = chain.get(state)
    if succs is None:
        return default

    assert isinstance(succs, dict)
    assert all(0. < prob <= 1. for prob in succs.values())

    choice = random.random()
    ranks, groups = tuple(itertools.accumulate(succs.values()))[1:], tuple(succs.keys())
    return utils.group_level(choice, ranks, groups)


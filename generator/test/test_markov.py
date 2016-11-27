

from generator import markov


def test_chain():
    chain = markov.chain('acab', order=1)
    assert chain == {('a',): {'c': .5, 'b': .5}, ('c',): {'a': 1.}}
    assert 'a' == markov.random_walk(chain, 'c')
    assert markov.random_walk(chain, 'a') in 'cb'


def test_random_walk():
    chain = markov.chain('abc', order=2)
    assert chain == {('a', 'b'): {'c': 1.}}
    assert 'c' == markov.random_walk(chain, 'ab')



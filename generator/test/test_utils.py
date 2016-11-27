

from generator import utils


def test_grouper():
    seq = 'abcdef'
    groups = (''.join(_) for _ in utils.grouper(seq, size=3))
    assert tuple(groups) == ('abc', 'def')


def test_sliding():
    seq = 'abcdef'
    windows = (''.join(_) for _ in utils.sliding(seq, size=3))
    assert tuple(windows) == ('abc', 'bcd', 'cde', 'def')


def test_group_level():
    # test found in bisect doc
    levels, groups = [60, 70, 80, 90], 'FDCBA'
    values, expected = [33, 99, 77, 70, 89, 90, 100], ['F', 'A', 'C', 'C', 'B', 'A', 'A']
    found = (utils.group_level(value, levels, groups)
             for value in values)
    assert tuple(found) == tuple(expected)

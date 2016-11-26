

from generator import classifier


def test_k_clustering():
    values, groups = [0, 1, 2, 3, 4, 5, 6], ['little', 'big']
    classified = tuple(classifier.k_clustering(values, groups))
    assert classified == tuple(['little'] * 4 + ['big'] * 3)

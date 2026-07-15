import pytest


@pytest.fixture
def sample_numbers():
    return 10, 5


@pytest.fixture
def sample_zero():
    return 0
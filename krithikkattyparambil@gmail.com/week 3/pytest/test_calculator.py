import pytest
from calculator import *


def test_add(sample_numbers):
    a, b = sample_numbers
    assert add(a, b) == 15


def test_subtract(sample_numbers):
    a, b = sample_numbers
    assert subtract(a, b) == 5


def test_multiply(sample_numbers):
    a, b = sample_numbers
    assert multiply(a, b) == 50


def test_divide(sample_numbers):
    a, b = sample_numbers
    assert divide(a, b) == 2


def test_square():
    assert square(5) == 25


def test_cube():
    assert cube(3) == 27


def test_negative_add():
    assert add(-2, -3) == -5


def test_negative_subtract():
    assert subtract(-5, -2) == -3


def test_zero_multiply():
    assert multiply(5, 0) == 0


def test_divide_by_zero():
    with pytest.raises(ValueError):
        divide(10, 0)
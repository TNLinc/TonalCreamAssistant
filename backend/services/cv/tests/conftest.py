from pathlib import Path

import numpy as np
import pytest
from cv2 import cv2
from werkzeug.datastructures import FileStorage

from main import app


@pytest.fixture
def test_dir():
    return Path(__file__).resolve().parent


@pytest.fixture
def test_data_dir(test_dir):
    return test_dir / "test_data"


@pytest.fixture
def face_test_image_path(test_data_dir):
    return test_data_dir / "face_test_image.jpeg"


@pytest.fixture
def no_face_test_image_path(test_data_dir):
    return test_data_dir / "no_face_test_image.jpg"


@pytest.fixture
def face_test_image(face_test_image_path):
    return cv2.imread(str(face_test_image_path))


@pytest.fixture
def face_test_image_bytes(face_test_image_path):
    return FileStorage(
        stream=open(str(face_test_image_path), "rb"),
        filename="face_test_image.jpeg",
        content_type="image/jpeg",
    )


@pytest.fixture
def no_face_test_image(no_face_test_image_path):
    return cv2.imread(str(no_face_test_image_path))


@pytest.fixture
def face_pixels_haar(test_data_dir):
    face_pixels_path = test_data_dir / "face_pixels.npy"
    return np.load(str(face_pixels_path))


@pytest.fixture
def client():
    with app.test_client() as client:
        yield client

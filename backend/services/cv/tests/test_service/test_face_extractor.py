import numpy as np

from services.face_extractor import HaarFaceExtractor, MediapipeFaceExtractor


def test_haar_face_extractor_correct_find_face(face_test_image):
    face_extractor = HaarFaceExtractor()
    faces = face_extractor._face_detection(face_test_image)
    assert np.all(faces == [[30, 56, 144, 144]])


def test_haar_face_extractor_correct_find_no_face(no_face_test_image):
    face_extractor = HaarFaceExtractor()
    faces = face_extractor._face_detection(no_face_test_image)
    assert faces == ()


def test_haar_face_extractor_correct_shape(face_test_image):
    face_extractor = HaarFaceExtractor()
    face_pixels = face_extractor.get_face_pixels(face_test_image)
    assert face_pixels.shape == (20736, 3)


def test_haar_face_extractor_correct_no_image_shape(no_face_test_image):
    face_extractor = HaarFaceExtractor()
    face_pixels = face_extractor.get_face_pixels(no_face_test_image)
    assert face_pixels is None


def test_mediapipe_face_extractor_correct_shape(face_test_image):
    face_extractor = MediapipeFaceExtractor()
    face_pixels = face_extractor.get_face_pixels(face_test_image)
    assert face_pixels.shape == (11289, 3)


def test_mediapipe_face_extractor_correct_no_image_shape(no_face_test_image):
    face_extractor = MediapipeFaceExtractor()
    face_pixels = face_extractor.get_face_pixels(no_face_test_image)
    assert face_pixels is None

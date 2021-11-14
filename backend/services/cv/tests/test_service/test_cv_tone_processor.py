from services.cv_tone_processor import CVToneProcessor


def test_cv_tone_processor_opencv_tone_process_works(face_test_image):
    tone_hex = CVToneProcessor().opencv_tone_process(face_test_image)
    assert tone_hex == "#b0826b"


def test_cv_tone_processor_mediapipe_tone_process_works(face_test_image):
    tone_hex = CVToneProcessor().mediapipe_tone_process(face_test_image)
    assert tone_hex == "#be8163"

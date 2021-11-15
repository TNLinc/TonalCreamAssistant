from services.tone_extractor import KMeanToneExtractor


def test_kmean_tone_extractor_works(face_pixels_haar):
    tone_rgb = KMeanToneExtractor().get_tone(face_pixels_haar)
    assert tone_rgb == (176, 130, 107)

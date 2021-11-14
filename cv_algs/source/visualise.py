import cv2.cv2 as cv2

from cv_algs.source.utils import show_palette
from services.cv_tone_processor import CVProcessor

TEST_IMAGE_PATH = '../data/w_sexy.jpeg'

if __name__ == "__main__":
    img = cv2.imread(TEST_IMAGE_PATH)
    cv_processor = CVProcessor.create('haar', 'kmean')
    hex_color = cv_processor.get_face_skin_tone(img)
    rbg_color = cv_processor.hex_to_rgb(hex_color)
    show_palette('First algorithm', img, rbg_color)

    cv_processor = CVProcessor.create('mediapipe', 'kmean')
    hex_color = cv_processor.get_face_skin_tone(img)
    rbg_color = cv_processor.hex_to_rgb(hex_color)
    show_palette('Second algorithm', img, rbg_color)

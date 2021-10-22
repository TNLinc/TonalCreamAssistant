from typing import List

import cv2
import numpy as np
from sklearn.cluster import KMeans


class CVFaceProcessor:
    def __init__(self):
        self.face_cascade = cv2.CascadeClassifier(
            "services/haarcascade/haarcascade_frontalface_default.xml"
        )
        self.k_means = KMeans(n_clusters=1)

    def face_detection(self, image: np.ndarray) -> List[tuple]:
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        return self.face_cascade.detectMultiScale(gray, 1.1, 4)

    @staticmethod
    def crop_face(
        image: np.ndarray, face: tuple, crop_coef_x: float = 0, crop_coef_y: float = 0
    ) -> np.ndarray:
        x_cropped = int((face[2] - face[0]) * crop_coef_x)
        y_cropped = int((face[1] - face[3]) * crop_coef_y)
        return image[
            face[1] + x_cropped : face[1] + face[3] - x_cropped,
            face[0] + y_cropped : face[0] + face[2] - y_cropped,
            :,
        ]

    def get_tone_rgb(self, image: np.ndarray) -> tuple[int]:
        self.k_means.fit(image.reshape(image.shape[0] * image.shape[1], 3))
        return tuple(map(int, self.k_means.cluster_centers_[0]))

    @staticmethod
    def rgb_to_hex(color: tuple) -> str:
        return f"#{color[2]:02x}{color[1]:02x}{color[0]:02x}"


class CVToneExtractor:
    def __init__(self):
        self.cv_face_processor = CVFaceProcessor()

    def get_skin_tone(self, image: np.ndarray):
        faces = self.cv_face_processor.face_detection(image)
        cropped_image = self.cv_face_processor.crop_face(image, faces[0])
        tone_color = self.cv_face_processor.get_tone_rgb(cropped_image)
        return self.cv_face_processor.rgb_to_hex(tone_color)


cv_tone_extractor = CVToneExtractor()

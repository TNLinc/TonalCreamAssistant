from abc import ABC, abstractmethod
from typing import List, Optional

import mediapipe as mp
import numpy as np
from backend.services.cv.core.settings import HAARCASCADE_DIR
from cv2 import cv2


class BaseFaceExtractor(ABC):
    @abstractmethod
    def get_face_pixels(self, image: np.ndarray) -> Optional[np.ndarray]:
        ...


class HaarFaceExtractor(BaseFaceExtractor):
    def __init__(self):
        self.face_cascade = cv2.CascadeClassifier(
            str(HAARCASCADE_DIR / "haarcascade_frontalface_default.xml")
        )

    def get_face_pixels(self, image: np.ndarray) -> Optional[np.ndarray]:
        faces = self._face_detection(image)
        if len(faces) == 0:
            return
        return self._crop_face(image, faces[0]).reshape(-1, 3)

    def _face_detection(self, image: np.ndarray) -> List[tuple]:
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        return self.face_cascade.detectMultiScale(gray, 1.1, 4)

    @staticmethod
    def _crop_face(
        image: np.ndarray, face: tuple, crop_coef_x: float = 0, crop_coef_y: float = 0
    ) -> np.ndarray:
        x_cropped = int((face[2] - face[0]) * crop_coef_x)
        y_cropped = int((face[1] - face[3]) * crop_coef_y)
        return image[
            face[1] + x_cropped : face[1] + face[3] - x_cropped,
            face[0] + y_cropped : face[0] + face[2] - y_cropped,
            :,
        ]


class MediapipeFaceExtractor(BaseFaceExtractor):
    LIPS_LANDMARKS = [
        0,
        37,
        39,
        40,
        185,
        61,
        146,
        91,
        181,
        84,
        17,
        314,
        405,
        321,
        375,
        291,
        409,
        270,
        269,
        267,
    ]

    FACE_LANDMARKS = [
        10,
        338,
        297,
        332,
        284,
        251,
        389,
        356,
        454,
        323,
        361,
        288,
        397,
        365,
        379,
        378,
        400,
        377,
        152,
        148,
        176,
        149,
        150,
        136,
        172,
        58,
        132,
        93,
        234,
        127,
        162,
        21,
        54,
        103,
        67,
        109,
    ]

    RIGHT_EYE_LANDMARKS = [
        244,
        233,
        232,
        231,
        230,
        229,
        228,
        31,
        35,
        156,
        70,
        63,
        105,
        66,
        107,
        55,
        193,
    ]

    LEFT_EYE_LANDMARKS = [
        464,
        453,
        452,
        451,
        450,
        449,
        448,
        261,
        265,
        383,
        300,
        293,
        334,
        296,
        285,
        417,
    ]

    def __init__(self):
        self.face_mesh = mp.solutions.face_mesh.FaceMesh(
            static_image_mode=True, max_num_faces=1
        )

    def get_face_pixels(self, image: np.ndarray) -> Optional[np.ndarray]:
        lips_points = []
        face_points = []
        right_eye_points = []
        left_eye_points = []

        ih, iw, ic = image.shape

        image_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        results = self.face_mesh.process(image_rgb)

        if not results.multi_face_landmarks:
            return

        face = results.multi_face_landmarks[0]

        for id, lm in enumerate(face.landmark):
            x, y = int(lm.x * iw), int(lm.y * ih)
            if id in self.LIPS_LANDMARKS:
                lips_points.append((id, x, y))
            if id in self.FACE_LANDMARKS:
                face_points.append((id, x, y))
            if id in self.RIGHT_EYE_LANDMARKS:
                right_eye_points.append((id, x, y))
            if id in self.LEFT_EYE_LANDMARKS:
                left_eye_points.append((id, x, y))

        elem_mask = np.uint8(np.zeros((ih, iw, 1)))
        face_mask = np.uint8(np.zeros((ih, iw, 1)))

        # lips
        start, first, second = None, None, None
        for id in range(len(self.LIPS_LANDMARKS) + 1):
            if id == len(self.LIPS_LANDMARKS):
                cv2.line(elem_mask, first, start, (255, 255, 255), 1)
                break
            for i in lips_points:
                if self.LIPS_LANDMARKS[id] == i[0] and first is None:
                    start = first = (i[1], i[2])
                elif self.LIPS_LANDMARKS[id] == i[0]:
                    second = (i[1], i[2])

                    cv2.line(elem_mask, first, second, (255, 255, 255), 1)
                    first = second

        # face
        start, first, second = None, None, None
        for id in range(len(self.FACE_LANDMARKS) + 1):
            if id == len(self.FACE_LANDMARKS):
                cv2.line(face_mask, first, start, (255, 255, 255), 1)
                break
            for i in face_points:
                if self.FACE_LANDMARKS[id] == i[0] and first is None:
                    start = first = (i[1], i[2])
                elif self.FACE_LANDMARKS[id] == i[0]:
                    second = (i[1], i[2])

                    cv2.line(face_mask, first, second, (255, 255, 255), 1)
                    first = second

        # right eye
        start, first, second = None, None, None
        for id in range(len(self.RIGHT_EYE_LANDMARKS) + 1):
            if id == len(self.RIGHT_EYE_LANDMARKS):
                cv2.line(elem_mask, first, start, (255, 255, 255), 1)
                break
            for i in right_eye_points:
                if self.RIGHT_EYE_LANDMARKS[id] == i[0] and first is None:
                    start = first = (i[1], i[2])
                elif self.RIGHT_EYE_LANDMARKS[id] == i[0]:
                    second = (i[1], i[2])

                    cv2.line(elem_mask, first, second, (255, 255, 255), 1)
                    first = second

        # left eye
        start, first, second = None, None, None
        for id in range(len(self.LEFT_EYE_LANDMARKS) + 1):
            if id == len(self.LEFT_EYE_LANDMARKS):
                cv2.line(elem_mask, first, start, (255, 255, 255), 1)
                break
            for i in left_eye_points:
                if self.LEFT_EYE_LANDMARKS[id] == i[0] and first is None:
                    start = first = (i[1], i[2])
                elif self.LEFT_EYE_LANDMARKS[id] == i[0]:
                    second = (i[1], i[2])

                    cv2.line(elem_mask, first, second, (255, 255, 255), 1)
                    first = second

        thresh = cv2.threshold(face_mask, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)[
            1
        ]
        contours, _ = cv2.findContours(
            thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE
        )
        cv2.fillPoly(face_mask, contours, (255, 255, 255))

        thresh = cv2.threshold(elem_mask, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)[
            1
        ]
        contours, _ = cv2.findContours(
            thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE
        )
        cv2.fillPoly(elem_mask, contours, (100, 100, 100))

        face_mask[elem_mask == 100] = 0

        return image[(face_mask != 0).repeat(repeats=3, axis=2)].reshape(-1, 3)


face_extractor_fabric = {
    "haar": HaarFaceExtractor(),
    "mediapipe": MediapipeFaceExtractor(),
}

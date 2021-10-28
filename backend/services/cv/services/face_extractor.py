from abc import ABC, abstractmethod
from typing import Dict, List, NamedTuple, Optional, Tuple

import mediapipe as mp
import numpy as np
from cv2 import cv2

from core.settings import HAARCASCADE_DIR


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
            return None
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
        0,
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
        10,
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
        244,
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
        464,
    ]

    def __init__(self):
        self.face_mesh = mp.solutions.face_mesh.FaceMesh(
            static_image_mode=True, max_num_faces=1
        )

    def get_face_pixels(self, image: np.ndarray) -> Optional[np.ndarray]:
        ih, iw, _ = image.shape
        image_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        results = self.face_mesh.process(image_rgb)

        if not results.multi_face_landmarks:
            return None

        face = results.multi_face_landmarks[0]
        (
            lips_points,
            face_points,
            right_eye_points,
            left_eye_points,
        ) = self._sort_landmarks(face=face, image_width=iw, image_height=ih)

        face_mask = np.uint8(np.zeros((ih, iw, 1)))
        elem_mask = np.uint8(np.zeros((ih, iw, 1)))

        self._draw_contour(
            canvas_image=face_mask, points=face_points, landmarks=self.FACE_LANDMARKS
        )

        self._draw_contour(
            canvas_image=elem_mask, points=lips_points, landmarks=self.LIPS_LANDMARKS
        )
        self._draw_contour(
            canvas_image=elem_mask,
            points=right_eye_points,
            landmarks=self.RIGHT_EYE_LANDMARKS,
        )
        self._draw_contour(
            canvas_image=elem_mask,
            points=left_eye_points,
            landmarks=self.LEFT_EYE_LANDMARKS,
        )

        self._fill_contour(face_mask, (255, 255, 255))
        self._fill_contour(elem_mask, (100, 100, 100))

        face_mask[elem_mask == 100] = 0

        return image[(face_mask != 0).repeat(repeats=3, axis=2)].reshape(-1, 3)

    def _sort_landmarks(
        self, face: NamedTuple, image_width: int, image_height: int
    ) -> tuple[
        Dict[int, Tuple[int, int]],
        Dict[int, Tuple[int, int]],
        Dict[int, Tuple[int, int]],
        Dict[int, Tuple[int, int]],
    ]:
        lips_points = {}
        face_points = {}
        right_eye_points = {}
        left_eye_points = {}

        for landmark_id, lm in enumerate(face.landmark):
            x, y = int(lm.x * image_width), int(lm.y * image_height)
            if landmark_id in self.LIPS_LANDMARKS:
                lips_points[landmark_id] = (x, y)
            if landmark_id in self.FACE_LANDMARKS:
                face_points[landmark_id] = (x, y)
            if landmark_id in self.RIGHT_EYE_LANDMARKS:
                right_eye_points[landmark_id] = (x, y)
            if landmark_id in self.LEFT_EYE_LANDMARKS:
                left_eye_points[landmark_id] = (x, y)

        return lips_points, face_points, right_eye_points, left_eye_points

    @staticmethod
    def _draw_contour(
        canvas_image: np.ndarray,
        points: Dict[int, Tuple[int, int]],
        landmarks: List[int],
    ):
        for i in range(1, len(landmarks)):
            cv2.line(
                canvas_image,
                points[landmarks[i - 1]],
                points[landmarks[i]],
                (255, 255, 255),
                1,
            )

    @staticmethod
    def _fill_contour(image: np.ndarray, color: Tuple[int, int, int]):
        thresh = cv2.threshold(image, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)[1]
        contours, _ = cv2.findContours(
            thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE
        )
        cv2.fillPoly(image, contours, color)


face_extractor_fabric = {
    "haar": HaarFaceExtractor(),
    "mediapipe": MediapipeFaceExtractor(),
}

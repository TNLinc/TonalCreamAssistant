from typing import Optional

import numpy as np
from PIL import ImageColor

from services.face_extractor import BaseFaceExtractor, face_extractor_fabric
from services.tone_extractor import BaseToneExtractor, tone_extractor_fabric


class CVProcessor:
    def __init__(
        self, face_extractor: BaseFaceExtractor, tone_extractor: BaseToneExtractor
    ):
        self.face_extractor = face_extractor
        self.tone_extractor = tone_extractor

    @classmethod
    def create(cls, face_extractor: str, tone_extractor: str):
        return cls(
            face_extractor=face_extractor_fabric[face_extractor],
            tone_extractor=tone_extractor_fabric[tone_extractor],
        )

    @staticmethod
    def rgb_to_hex(color: tuple) -> str:
        r, g, b = color
        return f"#{r:02x}{g:02x}{b:02x}"

    @staticmethod
    def hex_to_rgb(color: str) -> tuple:
        return ImageColor.getrgb(color)

    def get_face_skin_tone(self, image: np.ndarray) -> Optional[str]:
        face_skin_pixels = self.face_extractor.get_face_pixels(image)
        if face_skin_pixels is None:
            return
        rgb_tone = self.tone_extractor.get_tone(face_skin_pixels)
        return self.rgb_to_hex(rgb_tone)

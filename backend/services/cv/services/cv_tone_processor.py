from typing import Optional

import numpy as np

from services.chain.chain import Chain
from services.convertors import R2HConverterCell
from services.cv_context import CVContext
from services.face_extractor import FaceExtractorCell
from services.tone_extractor import ToneExtractorCell


class CVToneProcessor:
    @staticmethod
    def opencv_tone_process(image: np.ndarray) -> Optional[str]:
        chain = Chain(
            cells=[
                FaceExtractorCell(face_extractor="haar"),
                ToneExtractorCell(tone_extractor="kmean"),
                R2HConverterCell(),
            ]
        )
        context: CVContext = chain.process(CVContext(image))
        return context.tone_hex

    @staticmethod
    def mediapipe_tone_process(image: np.ndarray) -> Optional[str]:
        chain = Chain(
            cells=[
                FaceExtractorCell(face_extractor="mediapipe"),
                ToneExtractorCell(tone_extractor="kmean"),
                R2HConverterCell(),
            ]
        )
        context: CVContext = chain.process(CVContext(image))
        return context.tone_hex

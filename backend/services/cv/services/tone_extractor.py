from abc import ABC, abstractmethod
from typing import Tuple

import numpy as np
from sklearn.cluster import KMeans

from services.chain.cell import CellFromFabric
from services.cv_context import CVContext


class BaseToneExtractor(ABC):
    @abstractmethod
    def get_tone(self, face_pixels: np.ndarray) -> Tuple[int]:
        ...


class KMeanToneExtractor(BaseToneExtractor):
    def __init__(self):
        self.k_means = KMeans(n_clusters=1)

    def get_tone(self, face_pixels: np.ndarray) -> Tuple[int]:
        self.k_means.fit(face_pixels)
        bgr_center = tuple(map(int, self.k_means.cluster_centers_[0]))
        return bgr_center[::-1]


tone_extractor_fabric = {
    "kmean": KMeanToneExtractor(),
}


class ToneExtractorCell(CellFromFabric):
    def __init__(self, tone_extractor: str):
        super().__init__(fabric=tone_extractor_fabric, item_name=tone_extractor)

    def __call__(self, context: CVContext):
        context.tone_rgb = self._item.get_tone(context.face_pixels)
        return super().__call__(context=context)

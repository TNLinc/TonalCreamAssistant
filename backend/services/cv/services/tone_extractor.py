from abc import ABC, abstractmethod
from typing import Tuple

import numpy as np
from sklearn.cluster import KMeans


class BaseToneExtractor(ABC):
    @abstractmethod
    def get_tone(self, pixels: np.ndarray) -> Tuple[int]:
        ...


class KMeanToneExtractor(BaseToneExtractor):
    def __init__(self):
        self.k_means = KMeans(n_clusters=1)

    def get_tone(self, pixels: np.ndarray) -> Tuple[int]:
        self.k_means.fit(pixels)
        bgr_center = tuple(map(int, self.k_means.cluster_centers_[0]))
        return bgr_center[::-1]


tone_extractor_fabric = {
    "kmean": KMeanToneExtractor(),
}

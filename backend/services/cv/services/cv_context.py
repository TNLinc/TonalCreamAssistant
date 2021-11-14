import dataclasses
from typing import Optional, Tuple

import numpy as np


@dataclasses.dataclass
class CVContext:
    image: np.ndarray
    face_pixels: Optional[np.ndarray] = None
    tone_rgb: Optional[Tuple[int]] = None
    tone_hex: Optional[str] = None

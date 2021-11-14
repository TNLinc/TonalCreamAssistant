from PIL import ImageColor

from services.chain.cell import AbstractCell
from services.cv_context import CVContext


def rgb_to_hex(rgb_color: tuple) -> str:
    r, g, b = rgb_color
    return f"#{r:02x}{g:02x}{b:02x}"


def hex_to_rgb(hex_color: str) -> tuple:
    return ImageColor.getrgb(hex_color)


class R2HConverterCell(AbstractCell):
    def __call__(self, context: CVContext):
        context.tone_hex = rgb_to_hex(context.tone_rgb)
        return super().__call__(context=context)

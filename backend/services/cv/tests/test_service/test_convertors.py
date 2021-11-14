from services.convertors import hex_to_rgb, rgb_to_hex


def test_rgb_to_hex():
    rgb_color = (100, 100, 100)
    hex_color = rgb_to_hex(rgb_color)
    assert hex_color == "#646464"


def test_hex_to_rgb():
    hex_color = "#646464"
    rbg_color = hex_to_rgb(hex_color)
    assert rbg_color == (100, 100, 100)

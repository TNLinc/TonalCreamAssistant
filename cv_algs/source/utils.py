import numpy as np
from cv2 import cv2
from matplotlib import pyplot as plt


def show_palette(title, img, color):
    show_img_compar(title, img, create_palette(color))


def create_palette(color):
    width = 300
    palette = np.zeros((50, width, 3), np.uint8)
    palette[:, :, :] = color
    return palette


def show_img_compar(title, img_1, img_2):
    f, ax = plt.subplots(1, 2, figsize=(10, 10))
    ax[0].imshow(cv2.cvtColor(img_1, cv2.COLOR_BGR2RGB))
    ax[1].imshow(img_2)
    ax[0].axis("off")  # hide the axis
    ax[1].axis("off")
    f.tight_layout()
    f.suptitle(title, fontsize=32)
    plt.show()

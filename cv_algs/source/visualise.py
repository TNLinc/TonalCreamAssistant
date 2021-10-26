import cv2
import numpy as np
from matplotlib import pyplot as plt
from sklearn.cluster import KMeans


class CVFaceDetection:
    def __init__(self):
        self.face_cascade = cv2.CascadeClassifier("haarcascade_frontalface_default.xml")


def palette(clusters):
    width = 300
    palette = np.zeros((50, width, 3), np.uint8)
    steps = width / clusters.cluster_centers_.shape[0]
    for idx, centers in enumerate(clusters.cluster_centers_):
        palette[:, int(idx * steps) : (int((idx + 1) * steps)), :] = centers
    return palette


def show_img_compar(img_1, img_2):
    f, ax = plt.subplots(1, 2, figsize=(10, 10))
    ax[0].imshow(cv2.cvtColor(img_1, cv2.COLOR_BGR2RGB))
    ax[1].imshow(cv2.cvtColor(img_2, cv2.COLOR_BGR2RGB))
    ax[0].axis("off")  # hide the axis
    ax[1].axis("off")
    f.tight_layout()
    plt.show()


if __name__ == "__main__":
    face_cascade = cv2.CascadeClassifier("haarcascade_frontalface_default.xml")
    eye_cascade = cv2.CascadeClassifier("haarcascade_eye.xml")
    img = cv2.imread("test_img/w_sexy.jpeg")
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    face = face_cascade.detectMultiScale(gray, 1.1, 4)[0]
    eye_1 = eye_cascade.detectMultiScale(gray, 1.1, 4)[0]
    eye_2 = eye_cascade.detectMultiScale(gray, 1.1, 4)[1]
    face_img = img[
        face[1] : face[1] + face[3],
        face[0]
        + int((face[2] - face[0]) * 0.2) : face[0]
        + face[2]
        - int((face[2] - face[0]) * 0.2),
        :,
    ]
    print(face_img)
    cv2.rectangle(
        img,
        (eye_1[0], eye_1[1]),
        (eye_1[0] + eye_1[2], eye_1[1] + eye_1[3]),
        (255, 0, 0),
        2,
    )

    k_means = KMeans(n_clusters=1)
    k_means.fit(face_img.reshape(face_img.shape[0] * face_img.shape[1], 3))
    print(k_means.cluster_centers_)

    show_img_compar(face_img, palette(k_means))

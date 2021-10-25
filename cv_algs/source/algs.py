from argparse import ArgumentParser

import cv2
import mediapipe as mp
import numpy as np


def findFaceMask(img):
    # landmarks
    lips_landmarks = [
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
    ]
    face_landmarks = [
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
    ]
    right_eye_landmarks = [
        243,
        112,
        26,
        22,
        23,
        24,
        110,
        25,
        130,
        113,
        46,
        53,
        52,
        65,
        55,
        189,
    ]
    left_eye_landmarks = [
        463,
        341,
        256,
        252,
        253,
        254,
        339,
        255,
        359,
        342,
        276,
        283,
        282,
        295,
        285,
        413,
    ]

    # lists of points
    lips_points = []
    face_points = []
    right_eye_points = []
    left_eye_points = []

    ih, iw, ic = img.shape

    mpDraw = mp.solutions.drawing_utils
    mpFaceMesh = mp.solutions.face_mesh
    faceMesh = mpFaceMesh.FaceMesh(static_image_mode=True, max_num_faces=1)

    drawSpec = mpDraw.DrawingSpec(thickness=1, circle_radius=2)

    imgRGB = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    results = faceMesh.process(imgRGB)
    if results.multi_face_landmarks:
        for faceLms in results.multi_face_landmarks:
            mpDraw.draw_landmarks(img, faceLms, mpFaceMesh.FACEMESH_CONTOURS,
                                  drawSpec, drawSpec)

            for id, lm in enumerate(faceLms.landmark):
                x, y = int(lm.x * iw), int(lm.y * ih)
                if id in lips_landmarks:
                    lips_points.append((id, x, y))
                if id in face_landmarks:
                    face_points.append((id, x, y))
                if id in right_eye_landmarks:
                    right_eye_points.append((id, x, y))
                if id in left_eye_landmarks:
                    left_eye_points.append((id, x, y))

    elem_mask = np.uint8(np.zeros((ih, iw, 1)))
    face_mask = np.uint8(np.zeros((ih, iw, 1)))

    # lips
    start, first, second = None, None, None
    for id in range(0, len(lips_landmarks) + 1):
        if id == len(lips_landmarks):
            cv2.line(elem_mask, first, start, (255, 255, 255), 1)
            break
        for i in lips_points:
            if lips_landmarks[id] == i[0] and first == None:
                start = first = (i[1], i[2])
            elif lips_landmarks[id] == i[0]:
                second = (i[1], i[2])

                cv2.line(elem_mask, first, second, (255, 255, 255), 1)
                first = second

    # face
    start, first, second = None, None, None
    for id in range(0, len(face_landmarks) + 1):
        if id == len(face_landmarks):
            cv2.line(face_mask, first, start, (255, 255, 255), 1)
            break
        for i in face_points:
            if face_landmarks[id] == i[0] and first == None:
                start = first = (i[1], i[2])
            elif face_landmarks[id] == i[0]:
                second = (i[1], i[2])

                cv2.line(face_mask, first, second, (255, 255, 255), 1)
                first = second

    # right eye
    start, first, second = None, None, None
    for id in range(0, len(right_eye_landmarks) + 1):
        if id == len(right_eye_landmarks):
            cv2.line(elem_mask, first, start, (255, 255, 255), 1)
            break
        for i in right_eye_points:
            if right_eye_landmarks[id] == i[0] and first == None:
                start = first = (i[1], i[2])
            elif right_eye_landmarks[id] == i[0]:
                second = (i[1], i[2])

                cv2.line(elem_mask, first, second, (255, 255, 255), 1)
                first = second

    # left eye
    start, first, second = None, None, None
    for id in range(0, len(left_eye_landmarks) + 1):
        if id == len(left_eye_landmarks):
            cv2.line(elem_mask, first, start, (255, 255, 255), 1)
            break
        for i in left_eye_points:
            if left_eye_landmarks[id] == i[0] and first == None:
                start = first = (i[1], i[2])
            elif left_eye_landmarks[id] == i[0]:
                second = (i[1], i[2])

                cv2.line(elem_mask, first, second, (255, 255, 255), 1)
                first = second

    thresh = cv2.threshold(face_mask, 0, 255,
                           cv2.THRESH_BINARY + cv2.THRESH_OTSU)[1]
    cnts = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    cnts = cnts[0] if len(cnts) == 2 else cnts[1]
    cv2.fillPoly(face_mask, cnts, (255, 255, 255))

    thresh = cv2.threshold(elem_mask, 0, 255,
                           cv2.THRESH_BINARY + cv2.THRESH_OTSU)[1]
    cnts = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    cnts = cnts[0] if len(cnts) == 2 else cnts[1]
    cv2.fillPoly(elem_mask, cnts, (100, 100, 100))

    print(elem_mask[100][100])
    for y in range(ih):
        for x in range(iw):
            if elem_mask[y][x] == (100):
                face_mask[y][x] = 0

    return face_mask


# Arguments
arguments_parser = ArgumentParser()
arguments_parser.add_argument("-p", "--photo", help="Photo of the face")

args = arguments_parser.parse_args()

src_img = cv2.imread(args.photo, cv2.IMREAD_COLOR)
cv2.imshow("photo", src_img)
cv2.waitKey()

# Find the face
face_mask = findFaceMask(src_img)
cv2.imshow("face_mask", face_mask)
cv2.waitKey()

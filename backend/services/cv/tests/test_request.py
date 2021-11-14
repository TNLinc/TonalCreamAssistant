import json


def test_ht(client):
    r = client.get("/ht")
    assert r.status == "200 OK"


def test_opencv_skin_tone_v1(client, face_test_image_bytes):
    data = {"image": face_test_image_bytes}
    r = client.post(
        "/api/cv/v1/skin_tone", data=data, content_type="multipart/form-data"
    )
    json_response = json.loads(r.data)
    assert json_response == {"color": "#b0826b"}


def test_opencv_skin_tone_v2(client, face_test_image_bytes):
    data = {"image": face_test_image_bytes}
    r = client.post(
        "/api/cv/v2/skin_tone_opencv", data=data, content_type="multipart/form-data"
    )
    json_response = json.loads(r.data)
    assert json_response == {"color": "#b0826b"}


def test_mediapipe_skin_tone_v2(client, face_test_image_bytes):
    data = {"image": face_test_image_bytes}
    r = client.post(
        "/api/cv/v2/skin_tone_mediapipe", data=data, content_type="multipart/form-data"
    )
    json_response = json.loads(r.data)
    assert json_response == {"color": "#be8163"}

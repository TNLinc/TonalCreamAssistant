import http

import numpy as np
from cv2 import cv2
from flask_apispec import doc, marshal_with, use_kwargs
from werkzeug.datastructures import FileStorage

from api.v1.cv import bp
from schemas.color_schema import ColorSchema
from schemas.error_schema import ErrorSchema
from schemas.input_image_schema import InputImageSchema
from services.cv_tone_processor import CVToneProcessor


@bp.route("/skin_tone", methods=["POST"])
@doc(
    description="Search face on the photo and determine its skin color",
    tags=["tonal"],
    consumes=["multipart/form-data"],
)
@use_kwargs(InputImageSchema, location="files")
@marshal_with(schema=ColorSchema, code=200, description="Return color in hex code")
@marshal_with(schema=ErrorSchema, code=422, description="Problem with image file")
@marshal_with(schema=ErrorSchema, code=400, description="No face on the image")
def opencv_skin_tone_v1(image: FileStorage):
    np_img = np.fromstring(image.read(), np.uint8)
    image = cv2.imdecode(np_img, cv2.IMREAD_COLOR)
    color = CVToneProcessor.opencv_tone_process(image)

    if not color:
        error = {"files": {"image": ["No face on the image"]}}
        return ErrorSchema().dump({"error": error}), http.HTTPStatus.BAD_REQUEST

    response = dict(color=color)
    return ColorSchema().dump(response)

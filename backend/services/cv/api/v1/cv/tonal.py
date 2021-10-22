import cv2
import numpy as np
from flask_apispec import doc, marshal_with, use_kwargs
from werkzeug.datastructures import FileStorage

from api.v1.cv import bp
from schemas.color_schema import ColorSchema
from schemas.error_schema import ErrorSchema
from schemas.input_image_schema import InputImageSchema
from services.tonal_cv import cv_tone_extractor


@bp.route("/skin_tone", methods=["POST"])
@doc(
    description="Search face on the photo and determine its skin color",
    tags=["tonal"],
    consumes=["multipart/form-data"],
)
@use_kwargs(InputImageSchema, location="files")
@marshal_with(schema=ColorSchema, code=200, description="Return color in hex code")
@marshal_with(schema=ErrorSchema, code=400, description="Problem with file")
@marshal_with(schema=ErrorSchema, code=401, description="Wrong file extension")
def cv_skin_tone(image: FileStorage):
    np_img = np.fromstring(image.read(), np.uint8)
    image = cv2.imdecode(np_img, cv2.IMREAD_COLOR)
    response = dict(color=cv_tone_extractor.get_skin_tone(image))
    return ColorSchema().dump(response)

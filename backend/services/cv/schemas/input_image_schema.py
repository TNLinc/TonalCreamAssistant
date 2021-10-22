from marshmallow import Schema, fields

from utils.photo_upload import allowed_file


def image_validation(image):
    return bool(image.filename != "" and allowed_file(image.filename))


class InputImageSchema(Schema):
    image = fields.Field(
        description="Selfie",
        type="file",
        required=True,
        validate=image_validation,
        error_messages={
            "required": "No file found",
            "validator_failed": "Wrong image file format",
        },
    )

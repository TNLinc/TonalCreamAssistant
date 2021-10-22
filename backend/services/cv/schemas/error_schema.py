from marshmallow import Schema
from marshmallow.fields import String


class ErrorSchema(Schema):
    error = String()

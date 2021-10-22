from marshmallow import Schema
from marshmallow.fields import String


class ColorSchema(Schema):
    color = String()

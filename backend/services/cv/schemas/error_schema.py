from marshmallow import Schema
from marshmallow.fields import Dict


class ErrorSchema(Schema):
    error = Dict()

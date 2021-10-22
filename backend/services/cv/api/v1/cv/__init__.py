from flask import Blueprint

bp = Blueprint("cv", __name__, url_prefix="/api/cv/v1")  # type: Blueprint

from api.v1.cv.tonal import *

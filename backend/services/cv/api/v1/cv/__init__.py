from flask import Blueprint

bp = Blueprint("cv_v1", __name__, url_prefix="/api/cv/v1")  # type: Blueprint

from api.v1.cv.tonal import *

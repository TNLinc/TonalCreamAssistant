from flask import Blueprint

bp = Blueprint("cv_v2", __name__, url_prefix="/api/cv/v2")  # type: Blueprint

from api.v2.cv.tonal import *

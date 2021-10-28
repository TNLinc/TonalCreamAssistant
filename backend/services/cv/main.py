import json

from apispec import APISpec
from apispec.ext.marshmallow import MarshmallowPlugin
from flask import Flask
from flask_apispec import FlaskApiSpec, doc
from healthcheck import HealthCheck

from api.v1.cv import bp as cv_bp_v1
from api.v1.cv.tonal import cv_skin_tone_v1
from api.v2.cv import bp as cv_bp_v2
from api.v2.cv.tonal import cv_skin_tone_v2
from core import settings
from schemas.error_schema import ErrorSchema

description = """
CV API helps you do awesome stuff. 🚀

## Tonal

You will be able to:

* **Get tone of your skin by photo**
"""

spec = APISpec(
    openapi_version="2.0.0",
    title="Cv api",
    version="v1",
    plugins=[MarshmallowPlugin()],
    info={
        "description": description,
    },
)
spec.tag(
    {
        "name": "tonal",
        "description": "CV operations for tonal cream recommendation",
    }
)

app = Flask(__name__)
app.config.from_object(settings)

health = HealthCheck()


@app.route("/health")
@doc(
    description="Check service health",
)
def health_check():
    return json.loads(health.run()[0])


app.config.update(
    {
        "APISPEC_SPEC": spec,
        "APISPEC_SWAGGER_URL": settings.APISPEC_SWAGGER_URL,
        "APISPEC_SWAGGER_UI_URL": settings.APISPEC_SWAGGER_UI_URL,
    }
)
docs = FlaskApiSpec(app, document_options=False)

app.register_blueprint(cv_bp_v1)
app.register_blueprint(cv_bp_v2)
docs.register(cv_skin_tone_v1, blueprint=cv_bp_v1.name)
docs.register(cv_skin_tone_v2, blueprint=cv_bp_v2.name)
docs.register(health_check)


@app.errorhandler(422)
def handle_validation_error(err):
    exc = err.exc
    return ErrorSchema().dump({"error": exc.messages}), 422


if __name__ == "__main__":
    app.run()

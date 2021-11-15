from pathlib import Path

from environs import Env

env = Env()

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent

HAARCASCADE_DIR = BASE_DIR / "services/haarcascade"

env.read_env(str(BASE_DIR.parent.joinpath(".env")))

DEBUG = env.bool("CV_DEBUG", default=True)

CV_ALLOWED_HOSTS = env.list("CV_ALLOWED_HOSTS")

CV_SECRET_KEY = env("CV_SECRET_KEY")

APISPEC_SWAGGER_URL = "/api/cv/openapi.json"
APISPEC_SWAGGER_UI_URL = "/api/cv/openapi"

ALLOWED_EXTENSIONS = {"png", "jpg", "jpeg"}

from pathlib import Path

from environs import Env

env = Env()

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent

env.read_env(str(BASE_DIR.parent.joinpath(".env")))

PROJECT_NAME = "Vendor"
DB_URL = env("VENDOR_DB_URL")

DB_AUTH_SCHEMA = env("VENDOR_DB_AUTH_SCHEMA")

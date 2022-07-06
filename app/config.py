"""Flask configuration."""
from os import environ, path
from dotenv import load_dotenv

basedir = path.abspath(path.dirname(__file__))
load_dotenv(path.join(basedir, ".env"))

DEBUG = environ.get("DEBUG", "True").lower() in ("true", "1", "t")
TESTING = environ.get("TESTING", "True").lower() in ("true", "1", "t")

import multiprocessing
from os import environ, path
from dotenv import load_dotenv

basedir = path.abspath(path.dirname(__file__))
load_dotenv(path.join(basedir, ".env"))


bind = environ.get("BIND", "0.0.0.0:8000")
workers = int(environ.get("WORKERS", multiprocessing.cpu_count() * 2))
timeout = int(environ.get("REQUEST_TIMEOUT", 30))

loglevel = environ.get("LOG_LEVEL", "INFO")
accesslog = "-"
access_log_format = (
    "%(t)s %(h)s %(l)s %(u)s '%(r)s' %(s)s %(b)s '%(f)s' '%(a)s' in %(D)sµs"  #
)

reload = environ.get("DEBUG", "False").lower() in ("true", "1", "t")

from flask import Flask, jsonify, request, session
from datetime import timedelta
from time import sleep

VERSION = "0.1.1"


def create_app() -> Flask:
    """
    Create Flask app

    Returns:
        app: A fully configured flask application
    """

    app = Flask(__name__)
    app.config.from_pyfile("config.py")

    @app.before_request
    def make_session_permanent():
        session.permanent = True
        app.permanent_session_lifetime = timedelta(seconds=5)

    @app.route("/", methods=["GET"])
    def version():
        args = request.args
        runtime = int(args.get("runtime", default=0, type=int))
        if runtime > 0:
            sleep(runtime)

        return jsonify({"version": VERSION})

    return app

from flask import Flask, jsonify, request
from time import sleep

VERSION = "0.1.2"


def create_app() -> Flask:
    """
    Create Flask app

    Returns:
        app: A fully configured flask application
    """

    app = Flask(__name__)
    app.config.from_pyfile("config/settings.py")

    @app.route("/", methods=["GET"])
    def version():
        args = request.args
        runtime = int(args.get("runtime", default=0, type=int))
        if runtime > 0:
            sleep(runtime)

        return jsonify({"version": VERSION})

    return app

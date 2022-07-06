from flask import Flask, jsonify

VERSION = "0.1.0"


def create_app() -> Flask:
    """
    Create Flask app

    Returns:
        app: A fully configured flask application
    """

    app = Flask(__name__)
    app.config.from_pyfile("config.py")

    @app.route("/", methods=["GET"])
    def version():
        return jsonify({"version": VERSION})

    return app

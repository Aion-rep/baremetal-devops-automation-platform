import os
import socket

from flask import Flask, jsonify


def create_app():
    app = Flask(__name__)

    @app.get("/")
    def index():
        return jsonify(
            application="baremetal-devops-automation-platform",
            status="running",
            environment=os.getenv("APP_ENV", "development"),
            version=os.getenv("APP_VERSION", "dev"),
            hostname=socket.gethostname(),
        )

    @app.get("/health")
    def health():
        return jsonify(status="healthy"), 200

    return app


app = create_app()


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=int(os.getenv("PORT", "8080")),
    )

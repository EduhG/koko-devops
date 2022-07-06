import pytest
import socket
import urllib.request
from flask import url_for
from contextlib import nullcontext as does_not_raise

from app import VERSION


def test_version_get_endpoint(client):
    response = client.get("/")

    assert response.status_code == 200
    assert "version" in response.json
    assert VERSION == response.json["version"]


def test_version_endpoint_rejects_unexposed_method(client):
    response = client.post("/")
    assert response.status_code == 405


@pytest.mark.usefixtures("live_server")
class TestLiveServer:
    """
    A live test server to eneble us test request timeouts

    runtime - is the time(in seconds) the sever will take to process the request
    request_timeout - is the time(in seconds) the request times out if the server
        does not respond
    """

    @pytest.mark.parametrize(
        "runtime, request_timeout, expectation",
        [
            (0, 1, does_not_raise()),
            (2, 1, pytest.raises(socket.timeout)),
        ],
    )
    def test_version_endpoint_timeout(self, runtime, request_timeout, expectation):
        with expectation:
            url = url_for("version", _external=True, runtime=runtime)
            with urllib.request.urlopen(url, timeout=request_timeout) as response:
                assert response.code == 200

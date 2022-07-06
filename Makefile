dev:
	poetry run python manage.py

prod:
	poetry run gunicorn manage:app --workers 2 --bind 0.0.0.0:5000 --timeout 30 --log-level=DEBUG

test:
	pytest -v
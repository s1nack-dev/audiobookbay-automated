run:
	uv run python app/app.py

sync:
	uv sync --all-groups

test:
	uv run --group test pytest

lock:
	uv lock

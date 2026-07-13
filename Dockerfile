# Use uv from the official image.
FROM ghcr.io/astral-sh/uv:0.10.12 AS uv

# Use an official Python runtime as a parent image.
FROM python:3.10-slim

# Set the working directory in the container.
WORKDIR /app

# Copy uv and install locked runtime dependencies before application code.
COPY --from=uv /uv /uvx /bin/
ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_NO_CACHE=1
COPY pyproject.toml uv.lock ./
RUN uv sync --locked --no-dev --no-install-project

# Copy the application source.
COPY app /app

# Run the application without root privileges.
RUN addgroup --system app && adduser --system --ingroup app app
USER app

# Expose the port the app runs on
EXPOSE 5078

# Dependencies are installed by uv during the image build.
CMD [".venv/bin/python", "app.py"]

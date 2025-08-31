## Build Stage
FROM python:3.11-slim AS build
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt
COPY . .

## Runtime Stage
FROM gcr.io/distroless/python3-debian12
WORKDIR /app

## Distroless inherits Debian’s configuration, so its Python does not automatically search site-packages
ENV PYTHONPATH=/usr/local/lib/python3.11/site-packages
COPY --from=build /install /usr/local
COPY --from=build /app /app

## Special non-root user contianed in distroless and Google container images
USER 65532:65532

EXPOSE 8080
CMD ["-m", "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080"]

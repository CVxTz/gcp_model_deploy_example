
FROM python:3.8-slim as builder

WORKDIR "/app"

ENV PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    PYTHONUNBUFFERED=1

ENV PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VERSION=1.1.13



RUN pip install "poetry==$POETRY_VERSION"
RUN python -m venv /venv

COPY pyproject.toml poetry.lock ./
COPY ner_app ner_app

RUN . /venv/bin/activate && poetry install --no-dev --no-root
RUN . /venv/bin/activate && poetry build

FROM python:3.8-slim as final

WORKDIR "/app"

COPY --from=builder /venv /venv
COPY --from=builder /app/dist .
COPY ner_app ner_app

RUN . /venv/bin/activate && pip install *.whl

CMD ["/venv/bin/python", "-m", "uvicorn", "--app-dir", "ner_app", "app:app", "--host", "0.0.0.0", "--port", "5000", "--workers", "2"]

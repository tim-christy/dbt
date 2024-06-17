FROM python:3.9-slim-buster

# Update package management and add dbt's git dependency
RUN apt-get update \
    && apt-get install -y --no-install-recommends git curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV POETRY_VIRTUALSENV_CREATE=false \
    PATH="${PATH}:/root/.local/bin" \
    PYTHONPATH="${PYTHONPATH}:/opt/dagster/app/"

RUN pip install -U pip \
    && curl -sSL https://install.python-poetry.org | python3 -

COPY poetry.lock pyproject.toml ./

# Project init
RUN poetry config virtualenvs.create false --local \
    && poetry install --no-dev --no-interaction --no-ansi --no-root

WORKDIR /opt/dagster/app

COPY . /opt/dagster/app

FROM python:3.9

RUN apt-get update \
    && apt-get install --no-install-recommends ffmpeg=7:4.3.2-0+deb11u2 libsm6=2:1.2.3-1 libxext6=2:1.3.3-1.1 -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install poetry==1.1.11

WORKDIR /cv
COPY ./pyproject.toml /cv/

RUN poetry config virtualenvs.create false
RUN poetry install --no-interaction

COPY . .

CMD ["bash", "./scripts/flask-entrypoint.sh"]
FROM python:3.9

RUN pip install poetry==1.1.11

WORKDIR /vendor
COPY ./pyproject.toml /vendor/

RUN poetry config virtualenvs.create false
RUN poetry install --no-interaction

COPY . .

CMD ["bash", "./scripts/fastApi-entrypoint.sh"]
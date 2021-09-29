FROM python:3.9

RUN pip install poetry

WORKDIR admin_pannel
COPY ./poetry.lock ./pyproject.toml /admin_pannel/

RUN poetry config virtualenvs.create false
RUN poetry install --no-interaction

COPY . .

CMD ["bash", "scripts/django-entrypoint.sh"]

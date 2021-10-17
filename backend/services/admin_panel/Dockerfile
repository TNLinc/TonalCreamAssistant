FROM python:3.9

RUN pip install poetry==1.1.11

WORKDIR /admin_pannel
COPY ./pyproject.toml /admin_pannel/

RUN poetry config virtualenvs.create false
RUN poetry install --no-interaction

COPY . .

CMD ["bash", "scripts/django-entrypoint.sh"]

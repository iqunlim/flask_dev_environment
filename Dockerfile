FROM python:3.10-alpine AS base

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1  

RUN apk update && \
        apk add musl-dev libpq-dev gcc

RUN adduser -DS python

USER python

WORKDIR /home/python

ENV PATH="/home/python/.local/bin:$PATH"

RUN python3 -m pip install --upgrade pip

COPY --chown=python:python requirements.txt .

RUN --mount=type=cache,target=/home/python/.cache/pip \
        python3 -m pip install -r requirements.txt

EXPOSE 5000

FROM base AS dev

ENV FLASK_APP=/home/python/app/__init__.py
ENV FLASK_DEBUG=1

CMD ["python3", "-m", "flask", "run", "-h", "0.0.0.0", "-p", "5000"]

FROM base AS prod

COPY --chown=python:python ./app ./app

CMD ["gunicorn", "-w", "4","-b", "0.0.0.0:5000", "app:create_app()"]

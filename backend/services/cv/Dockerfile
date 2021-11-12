FROM amd64/python:3.9.8-bullseye

# requirements for opencv
RUN apt-get update && apt-get install --no-install-recommends\
    ffmpeg=7:4.3.2-0+deb11u2 \
    libsm6=2:1.2.3-1 \
    libxext6=2:1.3.3-1.1 -y \
    libavcodec58=7:4.3.2-0+deb11u2 \
    libavdevice58=7:4.3.2-0+deb11u2 \
    libavformat58=7:4.3.2-0+deb11u2 \
    libavfilter7=7:4.3.2-0+deb11u2 \
    libavresample4=7:4.3.2-0+deb11u2 \
    libavutil56=7:4.3.2-0+deb11u2 \
    libpostproc55=7:4.3.2-0+deb11u2 \
    libswresample3=7:4.3.2-0+deb11u2 \
    libswscale5=7:4.3.2-0+deb11u2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip==21.1.1 setuptools==58.3.0
RUN pip install poetry==1.1.11

WORKDIR /cv
COPY ./pyproject.toml /cv/

RUN poetry config virtualenvs.create false
RUN poetry install --no-interaction

COPY . .

CMD ["bash", "./scripts/flask-entrypoint.sh"]

FROM python:3.9.9-slim-buster

ENV INSTALL_PATH /usr/src/app
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONBUFFERED 1

WORKDIR $INSTALL_PATH

# install system dependencies
RUN apt-get update

# install python dependencies
RUN pip install --upgrade pip \
    && pip install poetry==1.0.5

COPY poetry.lock pyproject.toml ./

RUN poetry config virtualenvs.create false \
    && pip install --upgrade pip \
    && poetry install --no-dev

ARG USERNAME=app-user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

# copy project
COPY . .

# chown all the files to the app user
RUN chown -R $USERNAME $INSTALL_PATH

# change to the app user
USER $USERNAME

EXPOSE 5000

CMD ["gunicorn", "--workers=2", "--timeout=30", "--log-level=info", "--bind=0.0.0.0:5000", "manage:app"]

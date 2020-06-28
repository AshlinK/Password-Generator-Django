FROM python:3.7-alpine

MAINTAINER Ashlin Karkada

# Setting PYTHONUNBUFFERED=TRUE or PYTHONUNBUFFERED=1 (they are equivalent)
# allows for log messages to be immediately dumped to the stream instead of being
# buffered. This is useful for receiving timely log messages and avoiding
# situations where the application crashes without emitting a relevant message
# due to the message being "stuck" in a buffer.

ENV PYTHONUNBUFFERED=1

# Install postgresql
RUN apk add --update --no-cache postgresql-client
RUN apk add --update --no-cache --virtual .tmp-build-deps\
    gcc libc-dev linux-headers postgresql-dev

# Install dependencies for Pillow
RUN apk add --no-cache jpeg-dev zlib-dev
RUN apk add --no-cache --virtual .build-deps build-base linux-headers

# Copy and install requirements.txt file which contains all dependencies

COPY ./requirements.txt /requirements.txt
RUN python -m pip install --upgrade pip
RUN pip install -r /requirements.txt

RUN apk del .tmp-build-deps
# Create an empty directory called app and switch to that directory
# Copy all the contents of local directory into app

RUN mkdir /app
WORKDIR /app
COPY ./app /app

# Create a user ashlin
# -D Don't assign password and it is for running applications only.
# Switch to the user ashlin for security purposes.
RUN adduser -D ashlin
RUN chown -R ashlin /app
RUN chmod 777 /app
USER ashlin

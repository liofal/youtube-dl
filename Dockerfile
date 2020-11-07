# Specify base image
FROM python:3.9.0-alpine3.12 as base

# Build dependencies in python
FROM base as builder

# Install every build dependencies in builder image
# RUN apk add gcc musl-dev --no-cache
# RUN apk add libffi-dev openssl-dev --no-cache
RUN mkdir /install
WORKDIR /install
RUN pip install --upgrade pip
RUN pip install --prefix=/install --upgrade youtube-dl

# Run in minimal alpine container with no other dependencies
FROM base as runner
COPY --from=builder /install /usr/local
RUN apk add  --no-cache ffmpeg

# Configure entrypoint with environment variables (only user is mandatory)
ENTRYPOINT youtube-dl --newline -i --max-downloads ${maxdownloads} --format ${format} ${url}
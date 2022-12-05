# Specify base image
FROM python:3.11-alpine as base

# Build dependencies in python
FROM base as builder

# Install every build dependencies in builder image
RUN mkdir /install
WORKDIR /install
RUN pip install --upgrade pip

# install dependencies and build
ADD requirements.txt /install
RUN pip install --prefix=/install -r requirements.txt 

# Run in minimal alpine container with no other dependencies
FROM base as runner
COPY --from=builder /install /usr/local
# RUN apk add  --no-cache ffmpeg

# Configure entrypoint with environment variables (only user is mandatory)
ENTRYPOINT yt-dlp --newline --continue --fixup warn --max-downloads ${maxdownloads} --format ${format} --match-filter "!is_live" --output '%(uploader)s/%(upload_date)s-%(title)s-%(id)s.%(ext)s' ${url}
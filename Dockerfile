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
RUN apk add  --no-cache ffmpeg

# Add entrypoint script
COPY entrypoint.sh /entrypoint.sh
# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Configure entrypoint with shell script
ENTRYPOINT ["/entrypoint.sh"]
# Notes

# Usage

service definition is now through environment variable, multiple ways are supported, see here:
https://docs.docker.com/compose/environment-variables/

an easy way to make it dynamic:
ie:
```
export TWITCH=j_alexander_hs
docker-compose up youtube-dl
```

## 1.1.0
Upgrade to python:3.9.1-alpine3.12
ffmpeg fixup warn to avoid multiple reprocessing of already downloaded vod's.

might affect the integrity of the vods, as AAC was not fixed

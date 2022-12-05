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

## 2.0
youtube-dl being discontinued, migrate to [yt-dlp](https://github.com/yt-dlp/yt-dlp) fork of youtube-dl

## 1.3.1
Add retries default to 5

## 1.3
Upgrade to python 3.11
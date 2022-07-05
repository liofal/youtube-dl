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

## 1.2.2
Upgrade to python:3.10-alpine
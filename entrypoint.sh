#!/bin/sh

# Set default values if environment variables are not provided
: "${TWITCH:?TWITCH environment variable not set}"
: "${MAX_DOWNLOADS:=10}"
: "${FORMAT:=bestvideo*+bestaudio/best}"
: "${MATCH_FILTER:=live_status!=is_live}"

channel_url="https://www.twitch.tv/${TWITCH}"

download_videos() {
    playlist_start=$1
    yt-dlp --verbose --newline --continue --fixup warn --playlist-start "$playlist_start" \
           --max-downloads "${MAX_DOWNLOADS}" --format "${FORMAT}" \
           --retries 5 \
           --cookies /download/cookies.txt \
           --download-archive '/download/archive.fil' \
           --concurrent-fragments 5 --downloader aria2c --throttled-rate 100K --no-post-overwrites \
           --match-filter "${MATCH_FILTER}" \
           --output '/download/%(uploader)s/%(upload_date)s-%(title)s-%(id)s.%(ext)s' \
           $channel_url/videos/all

    status=$?
    if [ "$status" -eq 101 ]; then
        echo "yt-dlp reached the --max-downloads limit; treating as success."
        return 0
    fi

    return $status
}

# Capture the output of the yt-dlp command
output=$(yt-dlp --match-filter "${MATCH_FILTER}" $channel_url 2>&1)

# Check if the output contains the "skipping" message
if echo "$output" | grep -q "skipping"; then
    echo "The stream is live. Skipping the first video."
    # Download all videos, starting from the second one
    download_videos 2
else
    download_videos 1
fi

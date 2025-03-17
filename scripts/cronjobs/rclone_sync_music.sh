#! /bin/bash

source="$HOME/Music/Library/"
destination="nextcloud:/Music/Library/"
exclude="*DS_Store*"
logfile="./rclone_sync_music.log"

# Check if remote destination is accessible
if ! rclone lsf "$destination" &> /dev/null; then
  echo "Destination is not accessible."
  exit 1
fi

rclone sync "$source" "$destination" --checksum --exclude "$exclude" --delete-excluded --log-file "$logfile"

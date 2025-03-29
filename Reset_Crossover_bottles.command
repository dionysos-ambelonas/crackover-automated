#!/bin/bash

# Define the environment variable for the file path
FILE="$HOME/Library/Application Support/CrossOver/Bottles/Steam/system.reg"

# Define the backup file path
BACKUP="$FILE.bak"

# Define the search pattern
PATTERN="\[Software\\\\\\\\CodeWeavers\\\\\\\\CrossOver\\\\\\\\cxoffice\] [0-9]*"

# Create a backup of the original file
cp "$FILE" "$BACKUP"
echo "Backup created: $BACKUP"

# Find the line number where the pattern appears
LINE=$(grep -n "$PATTERN" "$FILE" | cut -d: -f1)

# If the pattern is found, print the matching lines and ask for confirmation
if [ -n "$LINE" ]; then
  echo "Match found at line $LINE."

  # Print the matching lines
  sed -n "${LINE},$(($LINE + 4))p" "$FILE"

  read -p "Do you want to delete these lines? (y/n): " ANSWER

  # If the user confirms, delete the lines
  if [ "$ANSWER" == "y" ]; then
    awk -v line="$LINE" 'NR >= line && NR <= line + 4 {next} {print}' "$FILE" > temp && mv temp "$FILE"
    echo "Lines deleted."
  else
    echo "Deletion canceled."
  fi
else
  echo "No match found."
fi

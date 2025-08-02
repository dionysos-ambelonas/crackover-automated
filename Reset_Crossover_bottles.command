#!/bin/bash

echo "CrossOver Complete Reset Utility"
echo "================================"
echo ""

# Step 0: Check and close CrossOver processes
echo "Step 0: Checking for running CrossOver processes..."

# Check if CrossOver is running
CROSSOVER_PIDS=$(pgrep -f "CrossOver" 2>/dev/null)
WINE_PIDS=$(pgrep -f "wine" 2>/dev/null)

if [ -n "$CROSSOVER_PIDS" ] || [ -n "$WINE_PIDS" ]; then
  echo "⚠ Found running CrossOver or Wine processes."
  echo "These processes will be terminated for a clean reset:"
  
  if [ -n "$CROSSOVER_PIDS" ]; then
    echo "CrossOver processes: $CROSSOVER_PIDS"
  fi
  
  if [ -n "$WINE_PIDS" ]; then
    echo "Wine processes: $WINE_PIDS"
  fi
  
  read -p "Terminate these processes? (y/n): " TERMINATE_ANSWER
  
  if [ "$TERMINATE_ANSWER" == "y" ]; then
    echo "Terminating CrossOver processes..."
    
    # Gracefully quit CrossOver first
    osascript -e 'tell application "CrossOver" to quit' 2>/dev/null
    sleep 2
    
    # Force kill any remaining CrossOver processes
    if [ -n "$CROSSOVER_PIDS" ]; then
      echo "$CROSSOVER_PIDS" | xargs kill -TERM 2>/dev/null
      sleep 1
      echo "$CROSSOVER_PIDS" | xargs kill -KILL 2>/dev/null
    fi
    
    # Force kill any remaining Wine processes
    if [ -n "$WINE_PIDS" ]; then
      echo "$WINE_PIDS" | xargs kill -TERM 2>/dev/null
      sleep 1
      echo "$WINE_PIDS" | xargs kill -KILL 2>/dev/null
    fi
    
    echo "✓ All CrossOver processes terminated."
    sleep 1
  else
    echo "⚠ Warning: Continuing with CrossOver processes running may cause issues."
    read -p "Continue anyway? (y/n): " CONTINUE_ANSWER
    if [ "$CONTINUE_ANSWER" != "y" ]; then
      echo "Script canceled."
      exit 1
    fi
  fi
else
  echo "✓ No CrossOver processes found running."
fi

echo ""

# First, reset the trial by modifying the plist file
echo "Step 1: Resetting CrossOver trial..."

# Path to CrossOver preferences
PLIST_FILE="$HOME/Library/Preferences/com.codeweavers.CrossOver.plist"

if [ -f "$PLIST_FILE" ]; then
  # Create backup of plist
  cp "$PLIST_FILE" "$PLIST_FILE.bak"
  echo "Backup of preferences created: $PLIST_FILE.bak"
  
  # Get today's date for trial reset
  TODAY=$(date -u +"%Y-%m-%d %H:%M:%S +0000")
  
  echo "Resetting CrossOver trial to today's date..."
  
  # Use defaults command to set FirstRunDate to today
  defaults write com.codeweavers.CrossOver FirstRunDate -date "$TODAY" 2>/dev/null
  
  if [ $? -eq 0 ]; then
    echo "✓ Trial reset successful! FirstRunDate set to today"
  else
    echo "⚠ Method 1 failed, trying alternative approach..."
    
    # Alternative method: Delete and recreate the key
    defaults delete com.codeweavers.CrossOver FirstRunDate 2>/dev/null
    defaults write com.codeweavers.CrossOver FirstRunDate -date "$(date '+%Y-%m-%d %H:%M:%S')" 2>/dev/null
    
    if [ $? -eq 0 ]; then
      echo "✓ Trial reset successful using alternative method"
    else
      echo "⚠ Could not reset trial date automatically"
    fi
  fi
  
  # Verify the change was made
  CURRENT_VALUE=$(defaults read com.codeweavers.CrossOver FirstRunDate 2>/dev/null)
  if [ -n "$CURRENT_VALUE" ]; then
    echo "✓ FirstRunDate is now: $CURRENT_VALUE"
  fi
  
else
  echo "⚠ Warning: CrossOver preferences file not found at $PLIST_FILE"
  echo "Make sure CrossOver is installed and has been run at least once."
fi

echo ""
echo "Step 2: Resetting bottle..."

# Ask user to choose which bottle to work with
read -p "Which CrossOver bottle would you like to reset? (e.g., Gameforge, Steam): " BOTTLE_NAME

# Define the environment variable for the file path
FILE="$HOME/Library/Application Support/CrossOver/Bottles/$BOTTLE_NAME/system.reg"

# Check if the bottle exists
if [ ! -f "$FILE" ]; then
  echo "Error: Bottle '$BOTTLE_NAME' not found at $FILE"
  echo "Please check the bottle name and try again."
  exit 1
fi

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
    echo "✓ Lines deleted successfully."
  else
    echo "Deletion canceled."
  fi
else
  echo "No match found."
fi

echo ""
echo "🎉 Complete reset finished!"
echo ""

# Step 3: Restart CrossOver
echo "Step 3: Starting CrossOver..."

read -p "Would you like to start CrossOver now? (y/n): " START_CROSSOVER

if [ "$START_CROSSOVER" == "y" ]; then
  echo "Starting CrossOver..."
  open -a "CrossOver"
  
  if [ $? -eq 0 ]; then
    echo "✓ CrossOver started successfully!"
    echo "The application should now show a fresh 14-day trial period."
  else
    echo "⚠ Failed to start CrossOver. You can start it manually."
  fi
else
  echo "You can start CrossOver manually when ready."
fi

echo ""
echo "IMPORTANT REMINDERS:"
echo "• Your trial should now be reset for another 14 days"
echo "• The bottle '$BOTTLE_NAME' has been reset"
echo "• Test by launching a program from the reset bottle"
echo "• Consider setting a reminder to repeat this process weekly"
echo ""

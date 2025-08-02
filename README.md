# CrossOver Complete Reset Utility

A comprehensive, automated script to reset both CrossOver's trial period and bottle expiration timers. This utility provides a one-command solution to extend your CrossOver trial and reset expired bottles.

## ✨ Features

- **🔄 Automatic Trial Reset**: Resets CrossOver's trial period to give you a fresh 14-day evaluation
- **🍾 Dynamic Bottle Reset**: Reset any CrossOver bottle by name (Steam, Gameforge, etc.)
- **🛡️ Process Management**: Automatically detects and safely closes CrossOver processes
- **📦 Automatic Backup**: Creates backups of all modified files for safety
- **🚀 Auto-Restart**: Optionally restarts CrossOver after the reset process
- **⚡ One-Command Solution**: No manual plist editing or file hunting required

## 🚀 Quick Start

### Prerequisites
- macOS with CrossOver installed
- Terminal access
- CrossOver bottles that need resetting

### Usage

1. **Download the script** to your preferred location
2. **Make it executable** (if needed):
   ```bash
   chmod +x Reset_Crossover_bottles.command
   ```
3. **Run the script**:
   ```bash
   ./Reset_Crossover_bottles.command
   ```

That's it! The script will guide you through the entire process.

## 📋 What the Script Does

### Step 0: Process Management
- Scans for running CrossOver and Wine processes
- Gracefully quits CrossOver application
- Force-terminates any remaining processes if needed
- Ensures a clean environment for modifications

### Step 1: Trial Reset
- Automatically backs up your CrossOver preferences
- Resets the `FirstRunDate` to today's date
- Gives you a fresh 14-day trial period
- No manual plist editing required!

### Step 2: Bottle Reset
- Prompts you to select which bottle to reset
- Locates and backs up the bottle's registry file
- Removes CrossOver licensing entries from the bottle
- Forces regeneration of fresh timestamps on next use

### Step 3: Restart
- Optionally launches CrossOver after the reset
- Verifies successful startup
- Provides helpful reminders and next steps

## 🎯 What to Expect

When you run the script, you'll see output like this:

```
CrossOver Complete Reset Utility
================================

Step 0: Checking for running CrossOver processes...
✓ No CrossOver processes found running.

Step 1: Resetting CrossOver trial...
Backup of preferences created: /Users/username/Library/Preferences/com.codeweavers.CrossOver.plist.bak
Resetting CrossOver trial to today's date...
✓ Trial reset successful! FirstRunDate set to today
✓ FirstRunDate is now: Fri Aug  2 15:30:45 2025

Step 2: Resetting bottle...
Which CrossOver bottle would you like to reset? (e.g., Gameforge, Steam): Steam
Backup created: /Users/username/Library/Application Support/CrossOver/Bottles/Steam/system.reg.bak
Match found at line 131948.
[Software\\CodeWeavers\\CrossOver\\cxoffice] 1754129822
#time=1dc0396970b74b2
"InstallTime"=dword:63d9d32b
"NagTime"=dword:65623b67
"Version"=dword:547445c7
Do you want to delete these lines? (y/n): y
✓ Lines deleted successfully.

🎉 Complete reset finished!

Step 3: Starting CrossOver...
Would you like to start CrossOver now? (y/n): y
Starting CrossOver...
✓ CrossOver started successfully!
The application should now show a fresh 14-day trial period.

IMPORTANT REMINDERS:
• Your trial should now be reset for another 14 days
• The bottle 'Steam' has been reset
• Test by launching a program from the reset bottle
• Consider setting a reminder to repeat this process weekly
```

## 🔧 Troubleshooting

### Common Issues

**"Bottle not found" error**
- Make sure you type the bottle name exactly as it appears in CrossOver
- Check that the bottle exists in `~/Library/Application Support/CrossOver/Bottles/`

**"No match found" in bottle**
- The bottle might already be reset or never had licensing entries
- This is normal for newly created bottles

**CrossOver still shows expired**
- Make sure all CrossOver processes were terminated before running the script
- Try running the script again
- Restart your Mac if issues persist

### Safety Features

- **Automatic Backups**: All modified files are backed up with `.bak` extensions
- **Process Verification**: Confirms CrossOver is properly closed before modifications
- **Non-Destructive**: Only removes specific licensing entries, preserves your bottle data
- **Rollback Capability**: Backups can be restored if anything goes wrong

## ⚠️ Important Notes

- **Close CrossOver First**: Always ensure CrossOver is completely closed before running
- **Regular Use**: Run weekly or when you encounter expiration messages
- **Backup Bottles**: Consider backing up important bottles before first use
- **Network**: Some users block CodeWeavers domains with firewalls (optional)

## 🤝 Contributing

This script combines techniques from the CrossOver community. The bottle reset method was adapted from community tutorials, and the trial reset approach was refined through testing.

## 📄 License

This utility is provided as-is for educational purposes. Use responsibly and in accordance with CrossOver's terms of service.

---

**Made with ❤️ for the CrossOver community**

# Gongfu Timer

A macOS menu bar timer for gongfu tea brewing. Lives in your menu bar as a leaf icon, counts down your steep, plays a sound when done, and automatically increments the duration for the next infusion.

## Features

- Countdown timer displayed directly in the menu bar
- Configurable base steep duration with +/- 5s nudge buttons
- Auto-incrementing steep time (0–15s per infusion)
- Steep counter to track your session
- Sound notification on completion
- Green leaf icon when your tea is ready

## Install

```
brew tap dfialkov/gongfu-timer
brew install --cask gongfu-timer
```

Or build from source:

```
git clone https://github.com/dfialkov/taskbar-gongfu-timer.git
cd taskbar-gongfu-timer
scripts/build.sh
open GongfuTimer.app
```

## Requirements

macOS 26 (Tahoe) or later.

## License

MIT

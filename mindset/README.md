# Mindset Sound Trigger

This project allows you to play a sound at full system volume by pressing a hotkey (F9 or Fn+F9).

## Requirements

- Linux (tested on Linux Mint with X11) 
---
   _These dependencies are typically satisfied on standard X11 installations:_
- Rust (Install via: [https://www.rust-lang.org/tools/install](https://www.rust-lang.org/tools/install))
- `xbindkeys`
- PulseAudio (typically preinstalled on most Linux distributions)
- `paplay` and `pactl` (part of `pulseaudio-utils`)

## Installation

1. **Clone the repository**

2. **Run the installer**

   ```bash
   chmod +x install.sh
   sudo ./install.sh

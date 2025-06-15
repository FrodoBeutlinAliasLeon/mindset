#!/bin/bash

# Only allow execution with sudo
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run with sudo"
  exit 1
fi

USER_HOME=$(eval echo "~$SUDO_USER")
CARGO_BIN="$USER_HOME/.cargo/bin"
XBINDSRC="$USER_HOME/.xbindkeysrc"

# Install required packages
if ! command -v curl &> /dev/null; then
  echo "Installing curl..."
  apt install -y curl
fi

if ! command -v xbindkeys &> /dev/null; then
  echo "Installing xbindkeys..."
  apt update && apt install -y xbindkeys
fi

if ! command -v pactl &> /dev/null; then
  echo "Installing pulseaudio-utils..."
  apt install -y pulseaudio-utils
fi

if ! dpkg -s build-essential &> /dev/null; then
  echo "Installing build-essential..."
  apt install -y build-essential
fi

# Check for Rust in user context
if ! sudo -u "$SUDO_USER" "$CARGO_BIN/cargo" --version &> /dev/null; then
  echo "Rust not found for user $SUDO_USER. Installing..."
  sudo -u "$SUDO_USER" curl https://sh.rustup.rs -sSf | sudo -u "$SUDO_USER" sh -s -- -y
fi

# Build Rust project
echo "Building the Rust program as $SUDO_USER..."
sudo -u "$SUDO_USER" env "PATH=$CARGO_BIN:$PATH" cargo build --release

# Copy binary
INSTALL_PATH="/usr/local/bin/mindset"
cp target/release/mindset "$INSTALL_PATH"

# Add hotkeys to .xbindkeysrc if not already present
mkdir -p "$USER_HOME"

# F9 = keycode 75
if ! grep -q 'c:75' "$XBINDSRC" 2>/dev/null; then
  echo '"/usr/local/bin/mindset"' >> "$XBINDSRC"
  echo '    m:0x0 + c:75' >> "$XBINDSRC"
fi

# Mod4 + i = keycode 31
if ! grep -q 'c:31' "$XBINDSRC" 2>/dev/null; then
  echo '"/usr/local/bin/mindset"' >> "$XBINDSRC"
  echo '    m:0x40 + c:31' >> "$XBINDSRC"
fi

# Change ownership of target files in case root touched them
chown -R "$SUDO_USER:$SUDO_USER" ./target

# Restart xbindkeys
echo "Restarting xbindkeys..."
pkill xbindkeys 2>/dev/null
sudo -u "$SUDO_USER" xbindkeys
echo ""
echo "Start the hotkeys (no sudo):"
echo ""
echo "   pkill xbindkeys"
echo "   xbindkeys"
echo ""


echo "✅ Installation complete. Mindset button is now bound to F9."

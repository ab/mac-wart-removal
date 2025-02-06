#!/usr/bin/env bash
set -eux

defaults write -g NSWindowShouldDragOnGesture -bool true

cat <<EOM
Enabled moving windows with Control-Command-<Click> ( ⌃ ⌘ <click> )

Now you can click to grab a window for moving from anywhere on the window, not
just the title bar.

You may need to restart for this to take effect.

For more configuration, try the 'Easy Move+Resize' app:
    brew install --cask easy-move+resize

EOM

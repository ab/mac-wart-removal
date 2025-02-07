#!/bin/sh
set -eux
# Disable setting where clicking on the wallpaper reveals the desktop / hides
# all windows
# https://apple.stackexchange.com/questions/468633/how-can-i-use-terminal-defaults-to-set-click-wallpaper-to-reveal-desktop-to-o
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

#!/bin/sh

dir="$HOME/Pictures/screenshots"

set -eux

mkdir -vp "$dir"

defaults write com.apple.screencapture location "$dir"

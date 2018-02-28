#!/bin/sh

set -eux

mkdir -vp ~/Desktop/screenshots

defaults write com.apple.screencapture location ~/Desktop/screenshots

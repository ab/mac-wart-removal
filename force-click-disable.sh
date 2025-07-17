#!/bin/bash
set -eu

set -x

defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool true

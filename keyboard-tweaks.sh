#!/bin/sh
set -eux

# Disable double spaces autocorrect -> period
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults read NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled

# Disable automatic smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults read NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled

# Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults read NSGlobalDomain NSAutomaticCapitalizationEnabled

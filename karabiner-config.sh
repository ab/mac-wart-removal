#!/bin/sh

# Keyboard settings for non-mac external keyboards

# This script sets karabiner configuration to remap the alt and win keys for
# more usable setup for non-mac external keyboards. It was generated with
# `karabiner export`.

cli=/usr/local/bin/karabiner

$cli set general.dont_remap_apple_keyboard 1
/bin/echo -n .
$cli set general.dont_remap_apple_pointing 1
/bin/echo -n .
$cli set remap.commandL2optionL 1
/bin/echo -n .
$cli set remap.optionL2commandL 1
/bin/echo -n .
$cli set remap.optionrcommandr 1
/bin/echo -n .
$cli set repeat.initial_wait 583
/bin/echo -n .
$cli set repeat.wait 33
/bin/echo -n .
/bin/echo

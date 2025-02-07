#!/usr/bin/env bash
set -euo pipefail

# fix <home> and <end> keys to work as expected
#
# https://apple.stackexchange.com/questions/16135/remap-home-and-end-to-beginning-and-end-of-line
#

dir=~/Library/KeyBindings
file="$dir/DefaultKeyBinding.dict"

mkdir -vp "$dir"

if [ -e "$file" ]; then
    echo >&2 "error: file already exists: $file"
    echo >&2 "Cowardly refusing to overwrite"
    exit 1
fi

set -o noclobber
set -x
tee "$file" <<'EOM'
{
    "\UF729"  = moveToBeginningOfLine:; // home
    "\UF72B"  = moveToEndOfLine:; // end
    "$\UF729" = moveToBeginningOfLineAndModifySelection:; // shift-home
    "$\UF72B" = moveToEndOfLineAndModifySelection:; // shift-end
}
EOM

cat <<EOM
Created $file
You may need to log out and back in for this to take effect
Then the <home> and <end> keys should work as expected
EOM

#!/bin/bash
set -eu

# Set caps lock to be control on all keyboards. This process is way more
# complicated than it should be because Apple.
#
# You can see current settings with: `defaults -currentHost read -g`

run() {
    echo >&2 "+ $*"
    "$@"
}

cleanup() {
    run rm -rf "$tmpdir"
}

log() {
    if [ -t 2 ]; then
        echo >&2 -ne "\033[1;34m"
    fi
    echo >&2 -n "$@"
    if [ -t 2 ]; then
        echo >&2 -ne "\033[m"
    fi
    echo >&2
}

tmpdir="$(mktemp -d -t caps-as-control)"
trap cleanup EXIT

log "Dumping list of keyboards"

# list keyboards as XML to get their ProductID and VendorID
ioreg_file="$tmpdir/ioreg.xml"
run ioreg -n IOHIDKeyboard -r -a > "$ioreg_file"

plistbuddy_run() {
    run /usr/libexec/PlistBuddy -c "$1" "$ioreg_file"
}

keyboards=()

log "Looking for VendorID and ProductID"

i=0
while plistbuddy_run "Print:$i" >/dev/null; do

    vendor_id="$(plistbuddy_run "Print:$i:VendorID")"
    product_id="$(plistbuddy_run "Print:$i:ProductID")"

    keyboards+=("${vendor_id}-${product_id}-0")

    i=$((i + 1))
done

log "Setting modifiers"

for kb in "${keyboards[@]}"; do
    log "Setting modifiers for keyboard $kb"
    full_name="com.apple.keyboard.modifiermapping.${kb}"

    # set caps lock to control
    run defaults -currentHost write -g "$full_name" -array \
        '<dict><key>HIDKeyboardModifierMappingSrc</key><integer>0</integer><key>HIDKeyboardModifierMappingDst</key><integer>2</integer></dict>'

done

cleanup
trap - EXIT

log "All done! Changes will take effect after logout."

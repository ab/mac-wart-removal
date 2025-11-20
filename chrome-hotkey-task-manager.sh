#!/usr/bin/env bash
set -euo pipefail

run() {
    echo >&2 "+ $*"
    "$@"
}

set_hotkey() {
    local app menu_item hotkey
    app="$1"
    menu_item="$2"
    hotkey="$3"

    cat <<EOM
--------------------------------------------------
Configuring keyboard shortcut:
App:    $app
Target: $menu_item
Hotkey: $hotkey
--------------------------------------------------
EOM

    run defaults write "$app" NSUserKeyEquivalents -dict-add "$menu_item" "$hotkey"

    # show new values
    run defaults read "$app" NSUserKeyEquivalents

    echo "You may need to restart the app for the new setting to take effect!"
}

add_to_custom_menu_apps() {
    local app
    app="$1"

    local ua_domain ua_key

    ua_domain="com.apple.universalaccess"
    ua_key="com.apple.custommenu.apps"

    local existing_apps
    existing_apps=$(run defaults read "$ua_domain" "$ua_key")

    # check if our app is already in the list
    if grep -qF "$app" <<< "$existing_apps"; then
        return
    fi

    echo "Adding $app to $ua_key"
    run defaults write "$ua_domain" "$ua_key" -array-add "$app"
}

echo "Setting Chrome hotkey for Task Manager to ⌘ Cmd + Esc"
echo

app=com.google.Chrome

add_to_custom_menu_apps "$app"

# @ = ⌘ Command (Cmd)
# ⎋ = Escape (Esc)
set_hotkey "$app" 'Task Manager' '@⎋'

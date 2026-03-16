-- When unplugging and replugging a Thunderbolt dock, it appears as a brand new
-- audio device, breaking any multi-device outputs. This breaks our loopback
-- device setup with BlackHole 2ch.
-- Fix this by toggling the use checkboxes of the old and new devices.
-- Co-authored by Claude Sonnet 4.6 and Gemini
--
-- Compile to app with this:
-- osacompile -o AudioLoopbackMultiDockFix.app audio-loopback-multi-dock-fix.applescript
--
-- That way you can grant just the applet accessibility control permissions and
-- not your whole terminal.


tell application "Audio MIDI Setup"
    activate
end tell

tell application "System Events"
    tell process "Audio MIDI Setup"
        log "--- Starting Audio Repair ---"

        repeat until exists window "Audio Devices"
            delay 0.2
        end repeat
        set mainWindow to window "Audio Devices"

        -- 1. Locate and select the Multi-Output device in the sidebar
        set multiOutputName to "Multi (CalDigit + BlackHole)"
        log "Looking for primary device: " & multiOutputName

        set foundMainDevice to false
        set sidebarRows to every row of outline 1 of scroll area 1 of splitter group 1 of mainWindow

        repeat with r in sidebarRows
            try
                set rowCell to UI element 1 of r
                set deviceName to missing value
                try
                    set deviceName to value of text field 1 of rowCell
                end try
                if deviceName is missing value then set deviceName to name of rowCell
                if deviceName is multiOutputName then
                    select r
                    set foundMainDevice to true
                    log "Success: Selected '" & multiOutputName & "' in sidebar."
                    exit repeat
                end if
            end try
        end repeat

        if not foundMainDevice then
            log "Error: Could not find the device '" & multiOutputName & "'."
            return
        end if

        delay 0.5

        -- 2. Target the sub-device table (right panel)
        set rightTable to table 1 of scroll area 2 of splitter group 1 of mainWindow

        -- 3. Find CalDigit entries
        set calDigitName to "CalDigit Thunderbolt 3 Audio"
        set blackHoleName to "BlackHole 2ch"
        set calDigitRows to {}

        repeat with r in every row of rightTable
            try
                if name of (UI element 2 of r) contains calDigitName then
                    set end of calDigitRows to r
                end if
            end try
        end repeat

        set rowCount to count of calDigitRows
        log "Found " & rowCount & " instance(s) of '" & calDigitName & "'."

        set madeChanges to false

        -- 4. Fix CalDigit routing
        if rowCount > 1 then
            log "Action: Multiple instances detected. Fixing routing..."

            -- Check the new (last) device FIRST, before unchecking the ghost.
            -- This way, when the ghost disappears and rows shift, the new device
            -- is already enabled and we don't need to re-find it.
            set newRow to item rowCount of calDigitRows
            set newCheck to checkbox 1 of (UI element 1 of newRow)
            if value of newCheck is 0 then
                click newCheck
                log "Success: Checked the active device."
            else
                log "Info: Active device was already checked."
            end if

            delay 0.3

            -- Now uncheck the ghost (first entry). It will disappear from the list.
            set oldRow to item 1 of calDigitRows
            set oldCheck to checkbox 1 of (UI element 1 of oldRow)
            if value of oldCheck is 1 then
                click oldCheck
                log "Success: Unchecked the ghost device."
            else
                log "Info: Ghost device was already unchecked."
            end if

            set madeChanges to true

        else if rowCount is 1 then
            log "Status: Only one instance found. Checking if it is enabled..."
            set singleRow to item 1 of calDigitRows
            set singleCheck to checkbox 1 of (UI element 1 of singleRow)
            if value of singleCheck is 0 then
                click singleCheck
                log "Success: Enabled the single available dock instance."
                set madeChanges to true
            else
                log "Status: Dock is already active."
            end if
        else
            log "Error: No devices named '" & calDigitName & "' found in the list."
        end if

        -- 5. Re-order BlackHole: uncheck then recheck so it appears after CalDigit
        --    (the first checked device becomes the clock source)
        if madeChanges then
            delay 0.5

            -- Re-scan the table since rows may have shifted after ghost removal
            set blackHoleRow to missing value
            repeat with r in every row of rightTable
                try
                    if name of (UI element 2 of r) is blackHoleName then
                        set blackHoleRow to r
                        exit repeat
                    end if
                end try
            end repeat

            if blackHoleRow is not missing value then
                set bhCheck to checkbox 1 of (UI element 1 of blackHoleRow)
                if value of bhCheck is 1 then
                    click bhCheck
                    log "Success: Unchecked BlackHole 2ch."
                    delay 0.3

                    -- Re-scan to get a fresh reference before rechecking
                    repeat with r in every row of rightTable
                        try
                            if name of (UI element 2 of r) is blackHoleName then
                                click checkbox 1 of (UI element 1 of r)
                                log "Success: Rechecked BlackHole 2ch (now after CalDigit)."
                                exit repeat
                            end if
                        end try
                    end repeat
                else
                    log "Info: BlackHole 2ch was not checked, skipping reorder."
                end if
            else
                log "Warning: Could not find BlackHole 2ch in the table."
            end if
        end if

        log "--- Audio Repair Finished ---"
    end tell
end tell

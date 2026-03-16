-- Print out the table of audio devices in the Audio MIDI Setup multi-device
-- listing. Useful for debugging audio-loopback-multi-dock-fix.applescript

tell application "Audio MIDI Setup" to activate
tell application "System Events"
    tell process "Audio MIDI Setup"
        repeat until exists window "Audio Devices"
            delay 0.2
        end repeat
        set mainWindow to window "Audio Devices"

        -- Select the multi-output device first
        set sidebarRows to every row of outline 1 of scroll area 1 of splitter group 1 of mainWindow
        repeat with r in sidebarRows
            try
                set rowCell to UI element 1 of r
                set deviceName to missing value
                try
                    set deviceName to value of text field 1 of rowCell
                end try
                if deviceName is missing value then set deviceName to name of rowCell
                if deviceName is "Multi (CalDigit + BlackHole)" then
                    select r
                    exit repeat
                end if
            end try
        end repeat

        delay 0.5

        -- Dump right-hand table
        set rightTable to table 1 of scroll area 2 of splitter group 1 of mainWindow
        set tableRows to every row of rightTable
        set output to "Right table row count: " & (count of tableRows) & linefeed
        set rowNum to 0
        repeat with r in tableRows
            set rowNum to rowNum + 1
            set output to output & "Row " & rowNum & ":" & linefeed
            set elems to every UI element of r
            set elemNum to 0
            repeat with e in elems
                set elemNum to elemNum + 1
                set eName to name of e
                set eDesc to description of e
                set output to output & "  UI element " & elemNum & ": name=[" & eName & "] desc=[" & eDesc & "]" & linefeed
                set subElems to every UI element of e
                repeat with se in subElems
                    set output to output & "    sub: name=[" & name of se & "] desc=[" & description of se & "] value=[" & (value of se as string) & "]" & linefeed
                end repeat
            end repeat
        end repeat
        return output
    end tell
end tell

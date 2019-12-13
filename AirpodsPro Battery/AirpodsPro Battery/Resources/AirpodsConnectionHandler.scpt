tell application "System Events"
    tell process "SystemUIServer"
        set btMenu to (menu bar item 1 of menu bar 1 whose description contains "bluetooth")
        tell btMenu
            click
            tell (menu item "{AIRPODS_NAME}" of menu 1) -- Mohamed’s AirPods not Mohamed's AirPods
                click
                if exists menu item "Connect" of menu 1 then
                    click menu item "Connect" of menu 1
                    return "Connecting..."
                else if exists menu item "Disconnect" of menu 1 then
                    click menu item "Disconnect" of menu 1
                    return "Disconnecting..."
                else
                    click btMenu -- Close main BT drop down if Connect wasn't present
                    return "Connect/disconncet menu was not found"
                end if
            end tell
        end tell
    end tell
end tell

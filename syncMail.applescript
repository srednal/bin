tell application "Mail"
	if it is running then
		repeat with a in every account
			synchronize with a
		end repeat
	end if
end tell
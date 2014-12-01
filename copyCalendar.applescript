tell application "Calendar"
	run
	
	set fromCalendar to calendar "Calendar"
	set toCalendar to calendar "WorkCopy"
	
	set yesterday to the (current date) - (24 * 60 * 60)
	set nextMonth to the (current date) + (31 * 24 * 60 * 60)
	
	set fromEvents to events of fromCalendar where end date is greater than yesterday and end date is less than nextMonth
	set toEvents to events of toCalendar where end date is greater than yesterday and end date is less than nextMonth
	
	repeat with anEvent in fromEvents
		tell anEvent
			set theSummary to summary
			set theDescription to description
			set theStart to start date
			set theEnd to end date
			set theAllDay to allday event
			set theRecurrence to recurrence
			set theLocation to location
		end tell
		
		set hasIt to false
		repeat with hasEvent in toEvents
			tell hasEvent
				if summary is theSummary and start date is theStart and end date is theEnd and allday event is theAllDay and recurrence is theRecurrence then
					set hasIt to true
				end if
			end tell
		end repeat
		
		log "Make " & theSummary & " @ " & theStart & ": " & (not hasIt)
		
		if hasIt is false then
			
			if theSummary is missing value then set theSummary to ""
			if theDescription is missing value then set theDescription to ""
			if theStart is missing value then set theStart to ""
			if theEnd is missing value then set theEnd to ""
			if theAllDay is missing value then set theAllDay to ""
			if theRecurrence is missing value then set theRecurrence to ""
			if theLocation is missing value then set theLocation to ""
			
			make new event in toCalendar at end with properties {summary:theSummary, description:theDescription, start date:theStart, end date:theEnd, allday event:theAllDay, location:theLocation}
			
		end if
		
	end repeat
	
	repeat with anEvent in toEvents
		tell anEvent
			set theSummary to summary
			set theStart to start date
			set theEnd to end date
			set theAllDay to allday event
			set theRecurrence to recurrence
		end tell
		
		set hasIt to false
		repeat with hasEvent in fromEvents
			tell hasEvent
				if summary is theSummary and start date is theStart and end date is theEnd and allday event is theAllDay and recurrence is theRecurrence then
					set hasIt to true
				end if
			end tell
		end repeat
		
		log "Remove " & theSummary & " @ " & theStart & ": " & (not hasIt)
		
		if hasIt is false then
			delete anEvent
		end if
		
	end repeat
	
	
	repeat with xEv in events of toCalendar
		tell xEv
			log "Have " & summary & " @ " & start date
		end tell
	end repeat
	
	
end tell

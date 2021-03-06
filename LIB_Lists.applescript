﻿---------------------------------------------
--	SCRIPT LIBRARY: LIST HANDLING
---------------------------------------------

-- HANDLER: Returns list as text string
to join(theList, delimiter)
	set TID to AppleScript's text item delimiters
	set AppleScript's text item delimiters to delimiter
	set theResult to theList as text
	set AppleScript's text item delimiters to TID
	return theResult
end join

-- HANDLER: Removes values from list
to filterList(listToFilter, valuesToOmit)
	set myResult to {}
	repeat with i in listToFilter
		if valuesToOmit does not contain i then set end of myResult to i as text
	end repeat
	return myResult
end filterList

-- HANDLER: Filters list by criterion
--	Note, criterion can be a handler!
--	Source: http://www.apeth.net/matt/unm/asph.html
on filter(L, crit)
	script filterer
		property criterion : crit
		on filter(L)
			if L = {} then return L
			if criterion(item 1 of L) then
				return {item 1 of L} & filter(rest of L)
			else
				return filter(rest of L)
			end if
		end filter
	end script
	return filterer's filter(L)
end filter
on isNumber(x)
	return ({class of x} is in {real, integer, number})
end isNumber
filter({"hey", 1, "ho", 2, 3}, isNumber)

-- HANDLER: Returns list of files as return-delimited text string
--	addStartupDrive allows prepending of disk name to each path
--	Required handlers: trimLinesRight
to fileListToText(theList, addStartupDrive)
	set theText to ""
	tell application "Finder"
		set hdName to get name of startup disk
	end tell
	repeat with i in theList
		set myPath to POSIX path of (i as alias)
		if addStartupDrive is true then set myPath to hdName & (myPath as text)
		set theText to theText & myPath & return
	end repeat
	return trimLinesRight(theText)
end fileListToText

-- HANDLER: Removes duplicate values from list
to uniqueValues(listToFilter)
	set myResult to {}
	repeat with i in listToFilter
		if myResult does not contain i then set end of myResult to i as text
	end repeat
	return myResult
end uniqueValues

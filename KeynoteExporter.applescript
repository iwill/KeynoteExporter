-- <Export Keynote to HTML>
-- https://iworkautomation.com/keynote/document-export.html#export-HTML

-- <Introduction to AppleScript Language Guide>
-- https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/introduction/ASLR_intro.html

-- command + shift + L: to show Library of Apps

-- <AppleScript Language Guide>
-- https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/introduction/ASLR_intro.html

-- <AppleScript 1-2-3>
-- http://macosxautomation.com/applescript/firsttutorial/index.html

-- THE DESTINATION FOLDER 
-- (see the "path" to command in the Standard Additions dictionary for other locations, such as pictures folder, movies folder, sites folder, desktop folder)
set the defaultDestinationFolder to (path to documents folder)

tell application "Keynote"
	activate
	try
		if playing is true then tell the front document to stop
		if not (exists document 1) then error number -128
		
		-- DERIVE NAME FOR NEW FOLDER FROM NAME OF THE FRONT DOCUMENT
		set documentName to the name of the front document
		if documentName ends with ".key" then Â
			set documentName to text 1 thru -5 of documentName
		
		-- CREATE AN EXPORT DESTINATION FOLDER
		-- IMPORTANT: ITÕS ADVISED TO ALWAYS CREATE A NEW DESTINATION FOLDER, AS THE CONTENTS OF ANY TARGETED FOLDER WILL BE OVERWRITTEN
		tell application "Finder"
			set newFolderName to documentName
			set incrementIndex to 1
			repeat until not (exists folder newFolderName of defaultDestinationFolder)
				set newFolderName to documentName & "-" & (incrementIndex as string)
				set incrementIndex to incrementIndex + 1
			end repeat
			set the targetFolder to Â
				make new folder at defaultDestinationFolder with properties Â
					{name:newFolderName}
			set the targetFolderHFSPath to targetFolder as string
		end tell
		
		-- EXPORT THE DOCUMENT
		with timeout of 1200 seconds
			export front document as HTML to file targetFolderHFSPath
		end timeout
		
	on error errorMessage number errorNumber
		display alert "EXPORT PROBLEM" message errorMessage
		error number -128
	end try
end tell

-- OPEN THE DESTINATION FOLDER
tell application "Finder"
	open the targetFolder
end tell

-- VIEW THE PRESENTATION
tell application "Safari"
	activate
	open file (targetFolderHFSPath & "index.html")
end tell

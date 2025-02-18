-- <Retrieving Presenter Notes>
-- https://iworkautomation.com/keynote/slide-presenter-notes.html#render-presenter-notes

-- <Saving Documents>
-- https://iworkautomation.com/keynote/document-save.html

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
		
		-- DERIVE NAME FOR NEW FILE FROM NAME OF THE FRONT DOCUMENT
		set textDocumentName to the name of the front document
		if textDocumentName ends with ".key" then Â
			set textDocumentName to text 1 thru -5 of textDocumentName
		set textDocumentName to textDocumentName & ".txt"
		
		-- EXPORT THE NOTES
		tell the front document
			set thisDocumentName to the name of it
			set the combinedPresenterNotes to Â
				"# PRESENTER NOTES FOR FILE:" & linefeed Â
				& thisDocumentName & linefeed
			repeat with i from 1 to the count of slides
				tell slide i
					if skipped is false then
						set the combinedPresenterNotes to combinedPresenterNotes & Â
							"## PRESENTER NOTES OF SLIDE " & (i as string) & ":" & linefeed Â
							& presenter notes of it & linefeed
					end if
				end tell
			end repeat
		end tell
		
	on error errorMessage number errorNumber
		display alert "EXPORT PROBLEM" message errorMessage
		error number -128
	end try
end tell

-- SAVE NOTES TO TEXT FILE
-- use `printf`, because `echo -n` does not work in AppleScript
do shell script "printf '" & combinedPresenterNotes & "' > ~/Documents/" & textDocumentName
tell application "Finder" to open file ((defaultDestinationFolder as text) & textDocumentName)

-- SAVE NOTES TO TEXT FILE
-- tell application "TextEdit"
-- 	activate
-- 	set textDocument to make new document with properties {text:combinedPresenterNotes}
-- 	save textDocument as text in file ((defaultDestinationFolder as text) & textDocumentName)
-- end tell

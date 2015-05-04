--================================
-- subanimTest.ms
--
-- by: Autodesk Scripting and SDK Learning Channel
-- [ youtube.com/user/scriptingsdkhowtos]
-- [ scriptingandsdkhowto@autodesk.com | scriptingandsdkhowto@gmail.com ]
--
-- The following script prints the currently selected object's 
-- hierarchy of sub-animatable objects (or "tracks") in the 
-- MaxScript Listener.
--
--================================
(
	function printAllSubanims pObj pDepth:0 = (
		for i in 1 to pObj.numSubs do (
			spaces = ""
			for j in 1 to pDepth do spaces += "    "
			print (spaces + (getSubAnimName pObj i asString:False))
			printAllSubanims pObj[i] pDepth:(pDepth+1)
		)
	)
	if selection[1] != undefined then (
		printAllSubanims selection[1] pDepth:1
	) else (
		print "no objects selected!"
	)
	OK
)
currentSelection = getCurrentSelection()



-- Get center point 
centerPosition = selection.center
-- max in rows 5 
-- COLS
rows = .0 
rowSpacing = 50.0

columns  = 5.0 
columnSpacing = 50.0







function array_allign currentSelection startPosition rows rowSpacing columnSpacing axis= 
(
	counter = 0.0
	incromenter = [0.0,0.0,0.0]
	
	for i in currentSelection do 
	(
		if counter == 0 then 
		(
			i.position = startPosition
		)
		else 
		(
			i.position = startPosition + incromenter
		)
		
		counter += 1
		--incromenter = 
		if mod counter rows == 0 then 
		(	
			---calculate x.y,z
			if axis == 1 then 
			(--xy
				x = (-1*rowSpacing)*(rows-1)
				y = columnSpacing
				z = 0 
			)	
			else if  axis == 2 then 
			(--yx	
				x = 0
				y = (-1*rowSpacing)*(rows-1)
				z = columnSpacing
			)	
			else 
			(--zx
				x = columnSpacing
				y = 0
				z = (-1*rowSpacing)*(rows-1)
			)			
			
			incromenter += [X,Y,Z]
		)
		else 
		(
			if axis == 1 then  
			(--"xy"	
				x = rowSpacing
				y = 0
				z = 0 
			)	
			else if  axis == 2 then
			(--"yz"
				x = 0
				y = rowSpacing
				z = 0 
			)
			else
			(--zx
				x = 0
				y = 0
				z = rowSpacing
			)
			incromenter += [x,y,z]
		)
	)
)





--- ARRAY GUI



--selection.center

-- numb rows 
-- numb colums

-- rowsSpacing
-- columsSpacing
selection.center
currentSelection.center
pos=[0,0,0]
currentSelection = getCurrentSelection()

for i in currentSelection do 
	pos += i.position

pos/(currentSelection.count-1)

currentSelection = getCurrentSelection()
select currentSelection
centerPoint = selection.center
clearSelection()
 


rollout live_grid_array_Rollout "LIVE GRID ARRAY" width:260 height:180
(	
	checkbox startAtCenter "Start at Center "  pos:[13,10] width:100 height:15 checked:true
	checkbox startAtOrigin "Start at Origin "  pos:[120,10] width:200 height:15 checked:false
	spinner X_txt "X:" fieldWidth:55 labelOnTop:false pos:[5,35] type:#float range:[-9999999999999999999999999,9999999999999999999999999,0.0]
	spinner Y_txt "Y:" fieldWidth:55 labelOnTop:false pos:[85,35] type:#float range:[-9999999999999999999999999,9999999999999999999999999,0.0]
	spinner Z_txt "Z:" fieldWidth:55 labelOnTop:false pos:[165,35] type:#float range:[-9999999999999999999999999,9999999999999999999999999,0.0]
	--GroupBox grp1 "GRID " pos:[4,10] width:230 height:160
	---checkbox rememberSelection "Remember Selection"  pos:[13,26] width:200 height:15 checked:true
	radiobuttons axes_type "Axes Type:"  labels:#("XY", "YZ", "XZ") pos:[13,60]
	--checkbox useDistanceLocater "Use Distance " pos:[13,30] width:100 height:15 
	--pickbutton pickDistance "Distance Object" pos:[100,30] width:125 height:18
	spinner lengthOfRow "Length of Row" pos:[13,100] width:199 height:16 range:[1,99999999,1] type:#integer 
	spinner spacingOfRow "Row Spacing   " pos:[13,125] width:199 height:16 range:[0,99999999,0] type:#float
	spinner spacingOfColumns "Column Spacing" pos:[13,150] width:199 height:16 range:[0,99999999,0] type:#float
	
	button offsetKeysBtn "Offset Selection" pos:[13,185] width:200 height:21
	
	
	on startAtCenter changed state do	
	(
		if startAtCenter.checked and startAtOrigin.checked do 
		(
			startAtOrigin.checked = false
		)
	)
	
	
	on startAtOrigin changed state do	
	(
		if startAtOrigin.checked and startAtCenter.checked do 
		(
			startAtCenter.checked = false
		)
	)
	

	on offsetKeysBtn pressed state do
	(
		currentSelection = getCurrentSelection()
		
		
		if startAtCenter.checked do
		(
			startingPosition = selection.center 
			X_txt.value= startingPosition[1]
			Y_txt.value = startingPosition[2]
			Z_txt.value = startingPosition[3]
		)
		if startAtOrigin.checked  do
		(	
			X_txt.value = 0.0
			Y_txt.value = 0.0
			Z_txt.value = 0.0
		)
		
		---startPosition = [0,0,0]
		--rememberSelection.value
		startPosition = [X_txt.value, Y_txt.value, Z_txt.value]
		array_allign currentSelection startPosition lengthOfRow.value spacingOfRow.value spacingOfColumns.value axes_type.state 		
	)
	
	on X_txt changed val do
	(
		if currentSelection != undefined do 
		(	
			startPosition = [X_txt.value, Y_txt.value, Z_txt.value] 
			array_allign currentSelection startPosition lengthOfRow.value spacingOfRow.value spacingOfColumns.value axes_type.state 
		)
	)
	
	on Y_txt changed val do
	(
		if currentSelection != undefined do 
		(	
			startPosition = [X_txt.value, Y_txt.value, Z_txt.value]
			array_allign currentSelection startPosition lengthOfRow.value spacingOfRow.value spacingOfColumns.value axes_type.state 
		)
	)
	
	
	on Z_txt changed val do
	(
		if currentSelection != undefined do 
		(	
			startPosition = [X_txt.value, Y_txt.value, Z_txt.value] 
			array_allign currentSelection startPosition lengthOfRow.value spacingOfRow.value spacingOfColumns.value axes_type.state 
		)
	)
	
	
	on lengthOfRow changed val do
	(
		if currentSelection != undefined do 
		(	
			startPosition = [X_txt.value, Y_txt.value, Z_txt.value]
			array_allign currentSelection startPosition lengthOfRow.value spacingOfRow.value spacingOfColumns.value axes_type.state 
		)
	)
	
	on spacingOfRow changed val do
	(
		if currentSelection != undefined do 
		(	
			startPosition = [X_txt.value, Y_txt.value, Z_txt.value] 
			array_allign currentSelection startPosition lengthOfRow.value spacingOfRow.value spacingOfColumns.value axes_type.state 
		)
	)
	
	on spacingOfColumns changed val do
	(
		if currentSelection != undefined do 
		(	
			startPosition = [X_txt.value, Y_txt.value, Z_txt.value]
			array_allign currentSelection startPosition lengthOfRow.value spacingOfRow.value spacingOfColumns.value axes_type.state 
		)
	)
	
	on axes_type changed state do
	(
		if currentSelection != undefined do 
		(	
			startPosition = [X_txt.value, Y_txt.value, Z_txt.value] 
			array_allign currentSelection startPosition lengthOfRow.value spacingOfRow.value spacingOfColumns.value axes_type.state 
		)
	)	
)



	
--// Drawing User Interface Window
screenHeight = sysInfo.desktopSize[2] --the second value in the point2 is the height
screenMiddle = screenHeight / 2

if Box_Offset_Toolbox_MasterFloater != undefined then CloseRolloutFloater Box_Offset_Toolbox_MasterFloater
Box_Offset_Toolbox_MasterFloater = newRolloutFloater "Live Grid Array v1.0" 255 375 380 (screenMiddle-450)
	
addRollout live_grid_array_Rollout Box_Offset_Toolbox_MasterFloater

currentSelection = ()



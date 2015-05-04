-- Live Grid Array 
-- V1.0
-- Created by Andrez Aguayo @ DK Studios
-- 10/21/2014
-- Creates a Live grid of the selected objects 
-- LIVE Features-:
--          -Adjust the Number if Rows 
--          -Adjust Spacing between obects 
--          -Adjust the starting position
-- 	    - Lenght, Width, Hight Spacing are based upon Min Max Value of the largest object. The 0 position will never have penetration  


-- COMING SOON: 
--         - Revert to original Position Button 




function array_allign currentSelection startPosition rows rowSpacing columns columnSpacing heightSpacing axis= 
(
	counter = 0.0
	rowsCounter = 0.0
	
	offsetSpacing = get_max_boundingBox_Distances currentSelection
	if axis == 1 then 
	(	
		rowSpacing += offsetSpacing[1]
		columnSpacing += offsetSpacing[2]
		heightSpacing += offsetSpacing[3]
	)
	else if axis == 2 then 
	(	
		rowSpacing += offsetSpacing[2]
		columnSpacing += offsetSpacing[3]
		heightSpacing += offsetSpacing[1]
	)
	else
	(	
		rowSpacing += offsetSpacing[3]
		columnSpacing += offsetSpacing[1]
		heightSpacing += offsetSpacing[2]
	)
	
	incromenter = [0.0,0.0,0.0]
	--print "here is my incromenter: " 
	--print incromenter
	
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
		-- if your numer of objects in a row is at it max then move over 
		if mod counter rows == 0 then 
		(	
			---calculate x.y,z
			if axis == 1 then 
			(--xy
				x = (-1*rowSpacing)*(rows-1)
				y = columnSpacing
				z = 0 
				rowsCounter +=1
				
				if mod rowsCounter columns == 0  do
				(
					x= (-1*rowSpacing)*(rows-1)
					y= (-1*columnSpacing)*(columns-1)
					z= heightSpacing
				)
			)	
			
			else if  axis == 2 then 
			(--yx	
				x = 0
				y = (-1*rowSpacing)*(rows-1)
				z = columnSpacing
				rowsCounter +=1
				
				if mod rowsCounter columns == 0 do
				(
					x= heightSpacing
					y= (-1*rowSpacing)*(rows-1)
					z= (-1*columnSpacing)*(columns-1)
				)
			)	
			else 
			(--zx
				x = columnSpacing
				y = 0
				z = (-1*rowSpacing)*(rows-1)
				rowsCounter +=1
				
				if mod rowsCounter columns == 0 do
				(
					x= (-1*columnSpacing)*(columns-1)
					y= heightSpacing
					z= (-1*rowSpacing)*(rows-1)
				)
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


function get_max_boundingBox_Distances myselection = 
(	
	-- so what I am doing here is a little cra cra
	-- first I am collecting all the min and max points of each object in to an array
	mydifferenceValues = for i in mySelection collect i.min - i.max
	-- then I am collecting the absolute value of each index value X 
	myAbsValXArray = for i in mydifferenceValues collect abs i[1]
	-- then I am collecting the absolute value of each index value Y
	myAbsValYArray = for i in mydifferenceValues collect abs i[2]
	-- then I am collecting the absolute value of each index value X 
	myAbsValZArray = for i in mydifferenceValues collect abs i[3]

	-- Because I am using absolute value I can simply get the max value of each list 
	MaxX = amax myAbsValXArray
	MaxY = amax myAbsValYArray
	MaxZ = amax myAbsValZArray
	
	-- this returnes the largest distance of each axis of each object
	return [MaxX,MaxY,MaxZ]
)



rollout live_grid_array_Rollout "DK Live Grid Array V 1.0" width:265 height:300
(	
	GroupBox startingPoint "LIVE Options" pos:[5,5] width:248 height:220
	label  startPositonLabel "Start Position:" pos:[10,25]
	spinner X_txt "X:" fieldWidth:55 labelOnTop:false pos:[10,45] type:#float range:[-9999999999999999999999999,9999999999999999999999999,0.0]
	spinner Y_txt "Y:" fieldWidth:55 labelOnTop:false pos:[90,45] type:#float range:[-9999999999999999999999999,9999999999999999999999999,0.0]
	spinner Z_txt "Z:" fieldWidth:55 labelOnTop:false pos:[170,45] type:#float range:[-9999999999999999999999999,9999999999999999999999999,0.0]
	--GroupBox grp1 "GRID " pos:[4,10] width:230 height:160
	---checkbox rememberSelection "Remember Selection"  pos:[13,26] width:200 height:15 checked:true
	radiobuttons axes_type "Axis Type:"  labels:#("XY", "YZ", "XZ") pos:[13,70] --columns:1
	--checkbox useDistanceLocater "Use Distance " pos:[13,30] width:100 height:15 
	--pickbutton pickDistance "Distance Object" pos:[100,30] width:125 height:18
	spinner lengthOfRow "Number of Rows:      " pos:[13,110] width:220 height:16 type:#integer range:[1,999999999,4] 
	spinner lengthOfColumn "Number of Columns:  " pos:[13,130] width:220 height:16 type:#integer range:[1,999999999,4] 
	
	spinner spacingOfRow "Length Spacing:     " pos:[13,160] width:220 height:16   type:#float range:[-99999999,9999999999999999999999999,0]
	spinner spacingOfColumns "Width Spacing:      " pos:[13,180] width:220 height:16 type:#float range:[-99999999,9999999999999999999999999,0] 
	spinner spacingOfHight "Hight Spacing:       " pos:[13,200] width:220 height:16 type:#float range:[-99999999,9999999999999999999999999,0] 
		
	checkbox startAtOrigin "Start at Origin "  pos:[13,235] width:100 height:15 checked:false
	checkbox startAtCenter "Start at Selection Center "  pos:[110,235] width:150 height:15 checked:true

	button offsetKeysBtn "MAKE GRID ARRAY ON SELECTION" pos:[25,255] width:200 height:40
	
	
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
	

	on offsetKeysBtn pressed  do
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
		
		array_allign currentSelection startPosition lengthOfRow.value spacingOfRow.value lengthOfColumn.value spacingOfColumns.value spacingOfHight.value axes_type.state 		
		
	)
	
	on X_txt changed val do
	(
		if currentSelection != undefined do 
		(		
		
			startPosition = [X_txt.value, Y_txt.value, Z_txt.value] 
			array_allign currentSelection startPosition lengthOfRow.value spacingOfRow.value lengthOfColumn.value spacingOfColumns.value spacingOfHight.value axes_type.state 
		)
	)
	
	on Y_txt changed val do
	(
		if currentSelection != undefined do 
		(	

			startPosition = [X_txt.value, Y_txt.value, Z_txt.value]
			array_allign currentSelection startPosition lengthOfRow.value spacingOfRow.value lengthOfColumn.value spacingOfColumns.value spacingOfHight.value axes_type.state 
		)
	)
	
	
	on Z_txt changed val do
	(
		if currentSelection != undefined do 
		(	
			startPosition = [X_txt.value, Y_txt.value, Z_txt.value] 
			array_allign currentSelection startPosition lengthOfRow.value spacingOfRow.value lengthOfColumn.value spacingOfColumns.value spacingOfHight.value axes_type.state 
		)
	)
	
	
	on lengthOfRow changed val do
	(
		if currentSelection != undefined do 
		(	
			startPosition = [X_txt.value, Y_txt.value, Z_txt.value]
			array_allign currentSelection startPosition lengthOfRow.value spacingOfRow.value lengthOfColumn.value spacingOfColumns.value spacingOfHight.value axes_type.state 
		)
	)
	

	on lengthOfColumn changed val do
	(
		if currentSelection != undefined do 
		(	
			startPosition = [X_txt.value, Y_txt.value, Z_txt.value]
			array_allign currentSelection startPosition lengthOfRow.value spacingOfRow.value lengthOfColumn.value spacingOfColumns.value spacingOfHight.value axes_type.state 
		)
	)
	
	
	on spacingOfRow changed val do
	(
		if currentSelection != undefined do 
		(	
			startPosition = [X_txt.value, Y_txt.value, Z_txt.value] 
			array_allign currentSelection startPosition lengthOfRow.value spacingOfRow.value lengthOfColumn.value spacingOfColumns.value spacingOfHight.value axes_type.state 
		)
	)
	
	on spacingOfColumns changed val do
	(
		if currentSelection != undefined do 
		(	
			startPosition = [X_txt.value, Y_txt.value, Z_txt.value]
			array_allign currentSelection startPosition lengthOfRow.value spacingOfRow.value lengthOfColumn.value spacingOfColumns.value spacingOfHight.value axes_type.state 
		)
	)
	
	on spacingOfHight changed val do
	(
		if currentSelection != undefined do 
		(	
			startPosition = [X_txt.value, Y_txt.value, Z_txt.value]
			array_allign currentSelection startPosition lengthOfRow.value spacingOfRow.value lengthOfColumn.value spacingOfColumns.value spacingOfHight.value axes_type.state 
		)
	)
	
	
	
	on axes_type changed state do
	(
		if currentSelection != undefined do 
		(	
			print axes_type.state 		
		
			startPosition = [X_txt.value, Y_txt.value, Z_txt.value] 
			array_allign currentSelection startPosition lengthOfRow.value spacingOfRow.value lengthOfColumn.value spacingOfColumns.value spacingOfHight.value axes_type.state  
		)
	)	
	

)

	
--// Drawing User Interface Window
screenHeight = sysInfo.desktopSize[2] --the second value in the point2 is the height
screenMiddle = screenHeight / 2

if arrayGUI != undefined do DestroyDialog arrayGUI
	
createDialog live_grid_array_Rollout "Live Grid Array v1.0" width:255 hight:550 ---380 (screenMiddle-450)
arrayGUI = live_grid_array_Rollout




--Clear  currentSelection
currentSelection = ()




--mySelection = getCurrentSelection()


--mySelection = getCurrentSelection()
--get_max_boundingBox_Distances myselection 

/*
myP = point()
myP2 = point()


myP.position = $.min
myP2.position =$.max
*/

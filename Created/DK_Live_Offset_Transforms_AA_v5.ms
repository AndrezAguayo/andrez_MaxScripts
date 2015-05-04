----------------------------------------------------------------------------------------------------------------------------
--/// Set up Functions                                                                                        ///--
----------------------------------------------------------------------------------------------------------------------------

function add_offset_attribute obj = 
(
	--- This Function creats a custom atter Time_Offset that is added to an
	--- empty modifier called Time Offest.  :) ---
	
	--Create the defintion for the custom attribute 
	TimeOffsetAtter = attributes Time_Offset 
	( 
		--Parameter block to store the tracks of animation 
		parameters main rollout:params
		( 
			--A track of animation 
			--Look under scripted plugins for the types that can be used. 
			animationTrack type:#float UI:Time_Offset_Spinner Default:0.00
		) 

		--The rollout that will show up in the modifier panel. 
		rollout params "Custom Attributes" 
		( 
			--The spinner that is connected to the animationTrack 
			spinner Time_Offset_Spinner "Time_Offset"  range:[-200,200,0]
		) 
	) 
	
	-- Make an empty Modifier to hold the attribute	
	eM=emptyModifier() 
	eM.Name = "Time_Offset"
	addModifier obj eM 
	--Add the Time Offset Atter. to the Modifier :) 
	custAttributes.add eM TimeOffsetAtter;
)


function add_position_scriptController obj  =
(
	-- create a Position List controller for the position controller
	obj.pos.controller = position_list()

	-- create a Position Script controller for the second Available position controller	& assign it
	ps = 	position_script()
	obj.pos.controller.Available.controller = ps
	
	return ps
)
function add_rotation_scriptController obj  =
(
	-- create a Position List controller for the position controller
	obj.rotation.controller = rotation_list()

	-- create a Position Script controller for the second Available position controller	& assign it
	rs = 	rotation_script()
	obj.rotation.controller.Available.controller = rs
	
	return rs
)

function add_scale_scriptController obj  =
(
	-- create a Position List controller for the position controller
	obj.scale.controller = scale_list()

	-- create a Position Script controller for the second Available position controller	& assign it
	ss = 	scale_script()
	obj.scale.controller.Available.controller = ss
	
	return ss
)



function script_controller_logic obj MasterObject ps= 
(	
	-- Assign a Node Variable to Script Controller: Master Box Transform Position
	ps.addNode "Master_Box" MasterObject

	-- Assign a Track Variable to the Script Controller: The objects "Time Offset" Atter.
	ps.addTarget "OffsetVal" obj[#Modified_Object][#Time_Offset].Time_Offset[#animationTrack]

	--  Create the expression string
	thePosExpression = "if Master_Box != undefined then\n"
	thePosExpression += "(\n"
	thePosExpression += "offsetValue = at time(currentTime - OffsetVal) Master_Box.position\n"
	thePosExpression += ("offsetValue - " + MasterObject.position as string +"\n")
	thePosExpression += ")\n"
	thePosExpression += "else\n"
	thePosExpression += "(\n"
	thePosExpression += "[0,0,0]\n"
	thePosExpression += ")"
	-- thePosExpression
	ps.SetExpression (thePosExpression)	

)


function collapse_script_controller_to_pos_controller obj = 
(	
	--get value if script crontroller
	myScriptVal = obj.pos.controller[2].value
	-- apply that shit to the postition xyx controller
	obj.pos.controller[1].value += myScriptVal
	-- reset the expression to defult 0,0,0
	thePosExpression = "[0,0,0]"
	obj.pos.controller[2].SetExpression (thePosExpression)	
)

function collapse_script_controller_to_rotation_controller obj = 
(	
	--get value if script crontroller
	myScriptVal = obj.rotation.controller[2].value
	rotationControllerVal =  obj.rotation.controller[1].value
	totalVal = myScriptVal + rotationControllerVal
	-- apply that shit to the postition xyz controller
	obj.rotation.controller[1].value = totalVal
	-- reset the expression to defult 0,0,0
	theRotateExpression = "quat 0 0 0 1"
	obj.rotation.controller[2].SetExpression (theRotateExpression)	
)

function rotation_script_controller_logic obj MasterObject rs= 
(	
	-- Assign a Node Variable to Script Controller: Master Box Transform Position
	rs.addNode "Master_Box" MasterObject

	-- Assign a Track Variable to the Script Controller: The objects "Time Offset" Atter.
	rs.addTarget "OffsetVal" obj[#Modified_Object][#Time_Offset].Time_Offset[#animationTrack]

	--  Create the expression string
	theRotatExpression = "if Master_Box != undefined then \n"
	theRotatExpression += "(\n"
	theRotatExpression += "offsetValue = at time(currentTime - OffsetVal) inverse Master_Box.rotation\n "
	--inversRotation = inverse Master_Box.rotation
	-- Grab the masterObjects rotation to use as an offset to keet the object in place
	masterObjectsOrigRotation =  MasterObject.rotation 
	theRotatExpression += "offsetValue + " + masterObjectsOrigRotation as string +"\n"
	theRotatExpression += ")\n"
	theRotatExpression += "else\n"
	theRotatExpression += "(\n"
	theRotatExpression += "(quat 0 0 0 1)\n"
	theRotatExpression += ")"
	-- thePosExpression
	rs.SetExpression (theRotatExpression)	

)

function scale_script_controller_logic obj MasterObject ss= 
(	
	-- Assign a Node Variable to Script Controller: Master Box Transform Position
	ss.addNode "Master_Box" MasterObject

	-- Assign a Track Variable to the Script Controller: The objects "Time Offset" Atter.
	ss.addTarget "OffsetVal" obj[#Modified_Object][#Time_Offset].Time_Offset[#animationTrack]

	--  Create the expression string
	theScaleExpression = "if Master_Box != undefined then\n"
	theScaleExpression += "(\n"
	theScaleExpression += "offsetValue = at time(currentTime - OffsetVal) Master_Box.scale\n"
	
	-- get differnce of current scale and offset scale 
	difference = obj.scale - MasterObject.scale 
	theScaleExpression += "offsetValue - " + difference as string +"\n"
	theScaleExpression += ")\n"
	theScaleExpression += "else\n"
	theScaleExpression += "(\n"
	theScaleExpression += "[1,1,1]\n"
	theScaleExpression += ")"
	-- thePosExpression
	ss.SetExpression (theScaleExpression)	

)


--rs = add_rotation_scriptController $
--add_offset_attribute $
--rotation_script_controller_logic $ $Box873 rs
--add_rotation_scriptController obj
--rotation_script_controller_logic obj MasterObject rs

function set_up_boxes mySelection masterObject = 
(	
	for obj  in mySelection do
	(	
		MasterObject = masterObject
		
		--- First check if the object already has a Time offset modifier already
		hasModifier = check_if_object_has_time_offset_modifier obj 
		if hasModifier == false do add_offset_attribute obj

		--- Check if it alreay has a Script Controller  else use one alreay made 
		hasPositionScript  = check_if_object_has_position_script obj
		if hasPositionScript  == false then 
		(	
			ps = add_position_scriptController obj
		)
		
		else 
		(
			collapse_script_controller_to_pos_controller obj
			ps = obj.pos.controller[2]
		)
		hasRotationScript  = check_if_object_has_rotaion_script obj
		if hasRotationScript == false then
		(
			rs = add_rotation_scriptController obj
		)
		else 
		(
			collapse_script_controller_to_rotation_controller
			rs = obj.rotation.controller[2]
		)
		--- Add Script Ctrl Logic, defines the Variables and sets up the expression for the Position and Rotation Script   
		
		ss = add_scale_scriptController obj
		scale_script_controller_logic obj MasterObject ss
		
		script_controller_logic obj MasterObject ps
		rotation_script_controller_logic obj MasterObject rs		
	)
)


--set_up_boxes $ $Teapot001

function object_is_in_selection obj mySelection = 
( --Check if an object is in an array 
	for i in mySelection do 
		if obj == i then return True
	return False
)	

function check_if_object_has_time_offset_modifier obj = 
( -- Check if Time Offest modifier is already part of this objects modifier list  	
	for i in obj.modifiers do
		if i.name == "Time_Offset" do return True		
	return False 
)	

function check_if_object_has_position_script obj = 
(-- Check of the object already has a script controller
	if obj.pos.controller[2].name == "Position Script" then return True
	else return False
)

function check_if_object_has_rotaion_script obj = 
(-- Check of the object already has a script controller
	if obj.rotation.controller[2].name == "Rotation Script" then return True
	else return False
)


-----------------------------------------------------------------------------------------------------------------------------
--/// Ease Function                                                                                              ///--
--// Ease Function are from Key Transfer  and edited By Andrez Aguayo                 ///--
--// Key Transfer  Created by John A. Martini and Andru Phoenix                           ///--
--// JokerMartini@hotmail.com -- www.JokerMartini.com                                       ///--
--// AndruServices@gmail.com -- www.bigseksi.com                                           ///--
----------------------------------------------------------------------------------------------------------------------------- 

function easeInOutCubic t b c d = 
(
	-- itemIndex Zero FramesTotal itemCount
	--_currentTime = t
	--_beginValue = b
	--_target = c
	--_duration = d
	
	if ((t / (d * 0.5)) < 1) then 
	( 
		t = t / (d * 0.5)
		return (c/2*t*t*t + b) 
	) else 
	(
		t = t / (d * 0.5)
		return (c/2*((t-=2)*t*t + 2) + b)
	)
)

function easeInCubic t b c d = 
(
	t = t/d
	return c*(t)*t*t + b;
)

function easeOutCubic t b c d = 
(
	t = t / d - 1 
	return c*((t)*t*t + 1) + b;
)

function easeInCirc t b c d = 
(
	t = t / d
	return -c * (sqrt (1 - (t)*t) - 1) + b;
)

function easeOutCirc t b c d = 
(
	t = t / d - 1 
	return c * ( sqrt (1 - (t)*t) ) + b;
)

function easeInOutCirc t b c d = 
(	
	if ((t / (d * 0.5)) < 1) then 
	(
		t = t / (d * 0.5)
		return -c/2 * (sqrt (1 - t*t) - 1) + b;
	) else
	(
		t = t / (d * 0.5)
		t = t - 2
		return c/2 * (sqrt (1 - (t)*t) + 1) + b;
	)
)

-- quick liner fuction does nothing 
function linear  t b c d = 
(
	return t
)

----------------------------------------------------------------------------------------------------------------------------
--/// Offset Functions                                                                                        ///--
----------------------------------------------------------------------------------------------------------------------------

function offset_time_attribute mySelection randomAmount offsetStart incAmount= 
(
	--- This function ofsets the  ofset Attribute. It also allows for some randomization if wanted
	--- Also takes in the Offset Start Value and the Offset incrament amount
	---------------------------------------------------------------------------------------------------------
	inc = offsetStart
	randomMax = 1+randomAmount
	randomMin = 1-randomAmount
	
	for obj in mySelection do 
	(
		--Check if obj has the offset Modifier 	
		 hasModifier = check_if_object_has_time_offset_modifier obj
		
		if hasModifier == True then 
		(	
			randomVal = random randomMin	randomMax;
			
			obj.modifiers[#Time_Offset].Time_Offset.animationTrack = inc*randomVal ;
		
			inc += incAmount
		)
		else 
		(
		message =  "Object: "+  obj.name as string + " is not a slave objecet.  Offset skipped on this ojbect." 
		print message
		)
	)
)


function scaleoffset mySelection scaleAmount = 
(
	--- This function ofsets the  ofset Attribute. It also allows for some randomization if wanted
	--- Also takes in the Offset Start Value and the Offset incrament amount
	---------------------------------------------------------------------------------------------------------

	
	for obj in mySelection do 
	(
		--Check if obj has the offset Modifier 	
		 hasModifier = check_if_object_has_time_offset_modifier obj
		
		if hasModifier == True then 
		(				
			obj.modifiers[#Time_Offset].Time_Offset.animationTrack *= scaleAmount ;
		)
		else print "object: "+  obj as string + "is not a slave objecet.  Offset skipped on this ojbect." 
	)
)



function offset_by_duration endValue startValue mySelection interpFunction = 
(	
	-- get the length of selection 
	--// get length of selectoin 
	--mySelection = getCurrentSelection() 
	selectionCount = mySelection.count
	--valueAtTime = startValue
	
	--  find the value of each offset and set it! :) 	
	b = startValue
	c = endValue
	d = endValue - startValue


	for i in 1 to mySelection.count do
	(
		t = (i as float) / (mySelection.count as float) * endValue
		
		myValue = interpFunction  t b c d
		--- print myValue
		mySelection[i].modifiers[#Time_Offset].Time_Offset.animationTrack = myValue
		
	)	
)	


function get_interp_type_from_spinner spinnerVal =
(	
	if spinnerVal == "Linear" then return linear 
	else if spinnerVal == "easeInOutCubic" then return easeInOutCubic 
	else if spinnerVal == "easeInCubic" then return easeInCubic 
	else if spinnerVal == "easeOutCubic" then return easeOutCubic 
	else if spinnerVal == "easeInCirc" then return easeInCirc 
	else if spinnerVal == "easeOutCirc" then return easeOutCirc 
	else if spinnerVal ==  "easeInOutCirc"  then return easeInOutCirc 
	else print "Crapp-olla something is messed up with the Interpration Type dropdownlist"
)


function select_by_distance  obj = 
(
	-- get current selection
	mySelection = getCurrentSelection();
	
	-- get an array of all the distances 
	distances = for i in mySelection collect distance obj i
	-- sort out the order of distances least to greatest 
	sortedDistances = sort distances
	-- create empty array
	newArray = #()
	-- for all the distances check for the object that has that distance and appen to the 
	-- array createing a new  array with of objects in the ordur if the distances 
	for i in distances do 
	(	
		for j in mySelection do
		(	
			if i == distance obj j do 
			(	
				newArray += j 
			)
		)
	)
	select newArray
)



----------------------------------------------------------------------------------------------------------------------------
--/// Building User Interface                                                                                ///--
----------------------------------------------------------------------------------------------------------------------------

rollout SetUp_Rollout "Set Up" --width:250 height:180
(
	label warning "Set Master then Select all the slaves" pos:[30,10] width:200 height:13
	pickbutton pickMaster "Select Master" pos:[15,35] width:200 height:21
	button applyOffestButton "Apply Offset Script " pos:[15,60] width:200 height:21
	-------------------------------------------------------------------------------------------------
	--// Button Handling
	-- Change the name desplayed on the pick button to the selected object
	on pickMaster picked obj do
	(
		if obj != undefined do
		(
			pickMaster.text = obj.name
		)
	)
	
	on applyOffestButton pressed do 
	(
		--print pickMaster.object
		mySelection = getCurrentSelection()
		
		MasterIsInSelection = object_is_in_selection pickMaster.object mySelection
		
		if  pickMaster.object != undefined   then  
		(	
			if MasterIsInSelection == False then
			(
				masterObject = pickMaster.object 
				set_up_boxes mySelection masterObject 
			)	
			else print "Hello Max User! Your Master Object can NOT be selected" 
			
		)	
		else print "Hello Max User! No Master Object is selected"
		
		myPoint = point name:"Distance_OffSet_Locater"
		
	)
)


rollout Offset_Rollout "Offset Functions" --width:250 height:180
(
	GroupBox grp1 "Offest By Selection" pos:[4,10] width:230 height:160
	--checkbox PcacheStart "Offset Start Frame" pos:[13,26] width:109 height:15 checked:true
	checkbox useDistanceLocater "Use Distance " pos:[13,30] width:100 height:15 
	pickbutton pickDistance "Distance Object" pos:[100,30] width:125 height:18
	spinner offsetStartValueSpnr "Offset Start Value " pos:[13,60] width:199 height:16 range:[-10000,10000,0] type:#float
	spinner offsetAmountSpnr "Offset Amount       " pos:[13,85] width:199 height:16 range:[-1000,1000,1] type:#float
	spinner randomAmountSpnr "Random Amount     " pos:[13,110] width:199 height:16 range:[0,1,0] type:#float
	
	button offsetKeysBtn "Offset Selection" pos:[13,135] width:200 height:21
	--button resetValues "Apply Offset Script " pos:[15,60] width:200 height:21
	
	GroupBox grp2 "Scale Offset" pos:[4,175] width:230 height:80
	--checkbox PcacheStart "Offset Start Frame" pos:[13,26] width:109 height:15 checked:true
	spinner ScaleAmount "Scale Amount " pos:[13,195] width:199 height:16 range:[-10,10,1] type:#float
	---spinner randomAmount "Random Amount     " pos:[13,55] width:199 height:16 range:[0,10,1] type:#float
	
	button ScaleOffsetButton  "Scale Offsets" pos:[13,220] width:200 height:21
	--button resetValues "Apply Offset Script " pos:[15,60] width:200 height:21
	
	GroupBox grp3 "Offset by Value" pos:[4,265] width:230 height:145
	spinner StartValueSpnr "Start Value " pos:[13,280] width:199 height:16 range:[-10000,10000,0] type:#float
	spinner EndValueSpnr "End Value   " pos:[13,305] width:199 height:16 range:[-1000,1000,10] type:#float
	dropdownlist interp_type "Interpration Type" width:199 height:16 items:#("Linear","easeInOutCubic", "easeInCubic", "easeOutCubic", "easeInCirc", "easeOutCirc", "easeInOutCirc")
	button OffsetByMinMaxButton  "Offset Selection Min/Max" pos:[13,380] width:200 height:21
	
	-------------------------------------------------------------------------------------------------
	--// Button Handling
	
	-- Change the name desplayed on the pick button to the selected object
	on pickDistance picked obj do
	(
		if obj != undefined do
		(
			pickDistance.text = obj.name
		)
	)
	
	
	on offsetKeysBtn pressed do
	(	-- if use disance is on & there is a offset object
		if useDistanceLocater.checked do
		(	--  run distance funciton 
			if  pickDistance.object != undefined   then  
			(
			select_by_distance pickDistance.object
			)
			else print "Hello Max User! There is no Distance Object Selected, Please select and object or uncheck 'Use Distance'" 
			
		
		)	
			
		mySelection = getCurrentSelection()
		randomAmount = randomAmountSpnr.value
		offsetStart = offsetStartValueSpnr.value

		incAmount = offsetAmountSpnr.value
		offset_time_attribute mySelection randomAmount offsetStart incAmount
	)
	
	on ScaleOffsetButton pressed do
	(
		mySelection = getCurrentSelection()
		scaleoffset mySelection scaleAmount.value
	)
	
	on OffsetByMinMaxButton pressed do
	(
		mySelection = getCurrentSelection()
		print "This is in the Offset By Min Max Button"
		interpFunction = get_interp_type_from_spinner interp_type.selected  
		offset_by_duration EndValueSpnr.value StartValueSpnr.value mySelection interpFunction
	)
	
)


	
--// Drawing User Interface Window
screenHeight = sysInfo.desktopSize[2] --the second value in the point2 is the height
screenMiddle = screenHeight / 2

if Box_Offset_Toolbox_MasterFloater != undefined then CloseRolloutFloater Box_Offset_Toolbox_MasterFloater
Box_Offset_Toolbox_MasterFloater = newRolloutFloater "Live Offset Toolbox v1.0" 255 575 380 (screenMiddle-450)
	
addRollout SetUp_Rollout Box_Offset_Toolbox_MasterFloater
addRollout Offset_Rollout Box_Offset_Toolbox_MasterFloater

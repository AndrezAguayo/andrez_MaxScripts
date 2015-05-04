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


function add_positionFollowScriptController obj MasterObject =
(
	-- create a Position List controller for the position controller
	obj.pos.controller = position_list()
		
	--obj.pos.controller.Available.controller = Position_XYZ ()
	--obj.pos.controller.setname 1 "OriginalAnim"
	--obj.pos.controller.active = 2
	--obj.pos.controller.weight[1] = 0
	-- $.pos.controller[1].controller = float_list ()

	-- create a Position Script controller for the second Available position controller	& assign it
	ps = 	position_script()
	obj.pos.controller.Available.controller = ps
		
	--obj.pos.controller[2].Z_Position.controller.setname 2 "SurfaceFollow"
	--obj.pos.controller[2].Z_Position.controller.active = 1

	-- Assign a Node Variable to Script Controller: Master Box Transform Position
	ps.addNode "Master_Box" MasterObject

	-- Assign a Track Variable to the Script Controller: The objects "Time Offset" Atter.
	ps.addTarget "OffsetVal" obj[#Modified_Object][#Time_Offset].Time_Offset[#animationTrack]

	--  Create the expression string
	thePosExpression = "offsetValue = at time(currentTime - OffsetVal) Master_Box.position\n"
	thePosExpression += ("offsetValue - " + MasterObject.position as string )
	
	
	-- thePosExpression
	ps.SetExpression (thePosExpression)	
)


currentSelection = getCurrentSelection()

for obj  in currentSelection do
(	
	MasterObject = $MasterBox;
	--obj = i ;
	--print "this is obj:"  
	--print obj 

	add_offset_attribute obj;
	add_positionFollowScriptController obj MasterObject;
)


--// Building User Interface
rollout SetUp_Rollout "Set Up" --width:250 height:180
(
	--GroupBox grp1 "LLAAALAAA" pos:[4,7] width:242 height:70
	--checkbox PcacheStart "Offset Start Frame" pos:[13,26] width:109 height:15 checked:true
	--spinner OffsetStartInput "Offset Amount" pos:[13,46] width:199 height:16 range:[-100,100,5] type:#integer
	
	--GroupBox grp1 "Execution" pos:[4,7] width:242 height:80
	label warning "Set Master then Select all the slaves" pos:[30,10] width:200 height:13
	button offsetKeys "Select Master" pos:[15,35] width:200 height:21
	button resetValues "Apply Offset Script " pos:[15,60] width:200 height:21
	-------------------------------------------------------------------------------------------------
	--// Button Handling
)


rollout Offset_Rollout "Offset Functions" --width:250 height:180
(
	GroupBox grp1 "Offest By Selection" pos:[4,10] width:230 height:120
	--checkbox PcacheStart "Offset Start Frame" pos:[13,26] width:109 height:15 checked:true
	spinner OffsetStartInput "Offset Start Value " pos:[13,30] width:199 height:16 range:[-1000000,1000000,1] type:#float
	spinner randomAmount "Random Amount     " pos:[13,55] width:199 height:16 range:[0,10,1] type:#float
	

	button offsetKeys "Offset Selection" pos:[13,75] width:200 height:21
	--button resetValues "Apply Offset Script " pos:[15,60] width:200 height:21
	
	GroupBox grp2 "Scale Offset" pos:[4,150] width:230 height:100
	--checkbox PcacheStart "Offset Start Frame" pos:[13,26] width:109 height:15 checked:true
	spinner ScaleAmount "Scale Amount " pos:[13,180] width:199 height:16 range:[-10,10,1] type:#float
	---spinner randomAmount "Random Amount     " pos:[13,55] width:199 height:16 range:[0,10,1] type:#float
	

	button ScaleOffset  "Scale Offsets" pos:[13,205] width:200 height:21
	--button resetValues "Apply Offset Script " pos:[15,60] width:200 height:21
	
	-------------------------------------------------------------------------------------------------
	--// Button Handling
)



--// Drawing User Interface Window
screenHeight = sysInfo.desktopSize[2] --the second value in the point2 is the height
screenMiddle = screenHeight / 2

if Box_Offset_Toolbox_MasterFloater != undefined then CloseRolloutFloater Box_Offset_Toolbox_MasterFloater
Box_Offset_Toolbox_MasterFloater = newRolloutFloater "Box Offset Toolbox v1.0" 255 500 380 (screenMiddle-450)
	
addRollout SetUp_Rollout Box_Offset_Toolbox_MasterFloater
addRollout Offset_Rollout Box_Offset_Toolbox_MasterFloater
--addRollout speedOffset_Rollout pointCacheToolbox_MasterFloater

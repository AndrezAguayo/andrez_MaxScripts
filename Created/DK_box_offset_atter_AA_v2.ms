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
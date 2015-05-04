function add_rotation_scriptController obj  =
(
	-- create a Position List controller for the position controller
	obj.rotation.controller = rotation_list()

	-- create a Position Script controller for the second Available position controller	& assign it
	rs = 	rotation_script()
	obj.rotation.controller.Available.controller = rs
	
	return rs
)

dog = inverse $.rotation
newDog = dog*.1
$.rotation = newDog

$.controller.rotation.x = ($Box016.controller.rotation.x)*.1
$.controller.rotation.y = ($Box016.controller.rotation.y)*.1
$.controller.rotation.z = ($Box016.controller.rotation.z)*.1



$.rotation = $Box016.rotation 


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


newObj = $
driverObj = $

add_offset_attribute newObj
-- Above object 
rs = add_rotation_scriptController newObj
MasterObject = driverObj
rotation_script_controller_logic newObj MasterObject rs







Master_Box = $Box001
OffsetVal = 2

if Master_Box != undefined then 
(
offsetValue = at time(currentTime - OffsetVal) inverse Master_Box.rotation
offsetValue = (offsetValue *.1)
 offsetValue + (quat 0 0.707107 0 0.707107)
)
else
(
(quat 0 0 0 1)
)



$.rotation 


function createCustomPointHelper pivotArg parentArg =
(
	for obj in selection do
	(
		-- Create point Helper
		myPoint = PointHelperObj box:on cross:off axistripod:off centermarker:on size:20
			
		-- Store min/ max of point helper
		myPointMin = myPoint.min
		myPointMax = myPoint.max
		
		-- Set Scale of Point Helper to match the Minimum and Maximum of our Object
		myPoint.scale.x = (abs(obj.min.x - obj.max.x)) / 10 -- divide by 10 becuase we already set the Size to 20 (10 is the radius of 20)
		myPoint.scale.y = (abs(obj.min.y - obj.max.y)) / 10
		myPoint.scale.z = (abs(obj.min.z - obj.max.z)) / 10
		
		ResetScale myPoint		
		
			
		-- Set position of Point helper to the center of our Obj
		print ("Object Center is : " + (obj.center as string))
		
			
		myPoint.position = obj.center

		--Match rotation of the object using an Orientation Constraint
		myPoint.rotation.controller = Orientation_Constraint()
		myPoint.rotation.controller.appendTarget obj 100.0
		myPoint.rotation.controller.relative = off
		myPoint.rotation.controller = Euler_XYZ()

		-- Match object pivot?
		case pivotArg of
		(
			1: myPoint.pivot = obj.position
			--1: ()
			2: ()
		)
		
		ResetTransform myPoint 
		
		-- Parent object to the poing helper? 
		case parentArg of
		(
			-- parent object to the point helper  
			1: obj.parent = myPoint
			-- NO PARENT, SAD CHILD :( 
			2: ()
		)
		
		
	)
) -- end of createCustomPointHelper function


-- createCustomPointHelper 1
try destroyDialog UI_Rollout catch()

rollout UI_Rollout "DK Create Point Helper" width:250
(
	group ""
	(
	-- define all your controls
		radiobuttons rbtn_pivot_options "Pivot Options:" labels:#("Object Pivot", "Center Pivot") default:1 columns:1
		radiobuttons rbtn_parent_options "Parent Options:" labels:#("Link Object to Helper", "No Link") default:1 columns:1
		
	)
	
	group ""
	(
		button btn_execute "Make Point Helper" align:#center	width:100
	)
	
	
		
	-- event handling
	-- This code handles what happens when buttons are pressed in the UI
	on btn_execute pressed do
	(
		undo on 
		(
			createCustomPointHelper rbtn_pivot_options.state rbtn_parent_options.state
		)	
	)
	
	
) --end of MyRollout

-- This piece of code creates a new dialog, which contains our rollout we defined earlier. If you remove this code then no UI will pop up for the user. The Rollout was defined but not
-- displayed in a dialog.
UI_Dialog =	createDialog UI_Rollout
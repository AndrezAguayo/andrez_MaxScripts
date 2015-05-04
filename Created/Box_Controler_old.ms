-- Create a  script controller
fs = float_script()


function addScriptCtrl obj MasterObject obj =
(

-- Store original animation in a list controller and turn off
$.pos.controller = position_list()
	
--obj.pos.controller.Available.controller = Position_XYZ ()
--obj.pos.controller.setname 1 "OriginalAnim"
--obj.pos.controller.active = 2
--obj.pos.controller.weight[1] = 0
-- $.pos.controller[1].controller = float_list ()

ps = 	position_script()
	
$.pos.controller.Available.controller = ps
	
ps.setname 2 "OffsetTime"
	
	
obj.pos.controller[2].Z_Position.controller.setname 2 "SurfaceFollow"
obj.pos.controller[2].Z_Position.controller.active = 1

thePosExpression = ("at time(currentTime - offset) masterBox.position")


-- thePosExpression

ps.SetExpression (thePosExpression)	

-- Assign a Track
ps.addNode $Master_Box

-- Assign a Controller
ps.addObject "OffsetVal" $.modifiers[#TimeOffset].Custom_Attributes.myOffset




em = EmptyModifier()
em.name = "offsetTime"
addModifier $ em
-- add offset pramater 




parameters Offset_Value

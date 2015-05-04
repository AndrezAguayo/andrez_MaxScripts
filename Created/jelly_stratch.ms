currenttime

tTime = (timeStamp()/25)


abs(tTime - 0 )


vTime = tTime



teaPotA = $
teaPotB = $

-- vPos is the current postion 
vPos = teaPotB.pos
-- vtime time 
vTime = 0.0
-- vVel is the 
vVel = [0,0,0]


Tension = 1.5
Damping = .5

-- line 1
tVec =(teaPotA.pos - vPos) * Tension

-- tPos = this.vPos + tVec + this.vVel
tPos = vPos + tVec + vVel


vPos = tPos

vVel = (tVec + vVel) * (1.0 - Damping)

-- submit result 
teaPotB.pos = tPos
currenttime

$vd_Ctrl_SpringMaster.modifiers[#Attribute_Holder].SpringCtrl.onOff= true






if Master_Box != undefined then
(
	offsetValue = at time(currentTime - OffsetVal) Master_Box.position
	offsetValue - [49.3698,88.036,0]
)

else
(
	[0,0,0]
)




function script_controller_logic obj MasterObject ps= 
(	-- Assign a Node Variable to Script Controller: Master Box Transform Position
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








add_offset_attribute obj

obj = $
MasterObject = $


add_offset_attribute obj
ps = add_position_scriptController obj
script_controller_logic obj MasterObject ps

















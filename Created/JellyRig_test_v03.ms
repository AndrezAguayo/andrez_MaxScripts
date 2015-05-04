function add_master_pulse_ctrl_attributes obj = 
(
	--- This Function creats a custom atter Time_Offset that is added to an
	--- empty modifier called Time Offest.  :) ---
	
	--Create the defintion for the custom attribute 
	Pulse_Attributes = attributes Pulse_Attributes 
	( 
		--Parameter block to store the tracks of animation 
		parameters main rollout:params
		( 	--A track of animation 
			--Look under scripted plugins for the types that can be used. 
			overAllAmpTrack type:#float UI:amp_Spinner Default:1.00
			pulseTrack type:#float UI:pulse_Spinner Default:0.0
		) 
		--The rollout that will show up in the modifier panel. 
		rollout params "Pulse Attributes" 
		( 	--The spinner that is connected to the animationTrack 
			spinner amp_Spinner "Amplitude"  range:[0,3,1]
			spinner pulse_Spinner "Pulse"  range:[-900000,900000,0]
		) 
	) 
	-- Make an empty Modifier to hold the attribute	
	eM=emptyModifier() 
	eM.Name = "Pulse_Attributes"
	addModifier obj eM 
	--Add the Time Offset Atter. to the Modifier :) 
	custAttributes.add eM Pulse_Attributes;
)


function add_master_vis_ctrl_attributes obj = 
(
	--- This Function creats a custom atter Time_Offset that is added to an
	--- empty modifier called Time Offest.  :) ---
	
	--Create the defintion for the custom attribute 
	vis_Attributes = attributes vis_Attributes 
	( 
		--Parameter block to store the tracks of animation 
		parameters main rollout:params
		( 	--A track of animation 
			--Look under scripted plugins for the types that can be used. 
			indivual_wave type:#float UI:indivual_wave_Spinner Default:0.00
			indivual_ctrls type:#float UI:indivual_ctrls_Spinner Default:0.0
		) 
		--The rollout that will show up in the modifier panel. 
		rollout params "Ctrl Visablity Attributes" 
		( 	--The spinner that is connected to the animationTrack 
			spinner indivual_wave_Spinner "Pulse Ctrls Vis"  range:[0,1,0]
			spinner indivual_ctrls_Spinner "individual Ctrls Vis"  range:[0,1,0]
		) 
	) 
	-- Make an empty Modifier to hold the attribute	
	--eM=emptyModifier() 
	--eM.Name = "Pulse_Attributes"
	--addModifier obj eM 
	--Add the Time Offset Atter. to the Modifier :) 
	custAttributes.add obj.modifiers[#Pulse_Attributes] vis_Attributes;
)


function add_sin_ctrl_attributes obj = 
(
	--- This Function creats a custom atter Time_Offset that is added to an
	--- empty modifier called Time Offest.  :) ---
	
	--Create the defintion for the custom attribute 
	Sin_Attributes = attributes Sin_Attributes 
	( 
		--Parameter block to store the tracks of animation 
		parameters main rollout:params
		( 	--A track of animation 
			--Look under scripted plugins for the types that can be used. 
			timeOffSetTrack type:#float UI:Time_Offset_Spinner Default:0.00
			amplitudeTrack type:#float UI:Amplitude_Spinner Default:0.5
			offsetYTrack type:#float UI:offsetY_Spinner Default:0.0
		) 

		--The rollout that will show up in the modifier panel. 
		rollout params "Custom Attributes" 
		( 
			--The spinner that is connected to the animationTrack 
			spinner Amplitude_Spinner "Amplitude"  range:[0,4,.5]
			spinner Time_Offset_Spinner "Sin_Offset"  range:[-200,200,0]
			spinner offsetY_Spinner "offsetY"  range:[-200,200,0]
			
		) 
	) 
	-- Make an empty Modifier to hold the attribute	
	eM=emptyModifier() 
	eM.Name = "Sin_Attributes"
	addModifier obj eM 
	--Add the Time Offset Atter. to the Modifier :) 
	custAttributes.add eM Sin_Attributes;
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




function rotation_script_controller_logic obj MasterObject rs= 
(	
	-- Assign a Node Variable to Script Controller: Master Box Transform Position
	-- rs.addNode "Master_Box" MasterObject
	rs.addTarget "const" MasterObject[#Modified_Object][#Pulse_Attributes].Pulse_Attributes[#PulseTrack]
	rs.addTarget "overAllAmp" MasterObject[#Modified_Object][#Pulse_Attributes].Pulse_Attributes[#overAllAmpTrack]
	
	
	-- Assign a Track Variable to the Script Controller: The objects "Time Offset" Atter.
	rs.addTarget "Offset_X" obj[#Modified_Object][#Sin_Attributes].Sin_Attributes[#timeOffSetTrack]
	rs.addTarget "amplitude" obj[#Modified_Object][#Sin_Attributes].Sin_Attributes[#amplitudeTrack]
	rs.addTarget "offsetY" obj[#Modified_Object][#Sin_Attributes].Sin_Attributes[#offsetYTrack]
	
	--  Create the expression string
	
	theRotatExpression = "if const != undefined then \n"
	theRotatExpression += "(\n"
	--theRotatExpression += "-- get sin OFFEST VALUE\n"
	theRotatExpression += "sinValOFF = (sin(0- offset_X)*amplitude)\n"
	--theRotatExpression += "-- calculate the value of the rotation\n"
	theRotatExpression += "sinVal = ((sin(const- offset_X))*amplitude*overAllAmp) - sinValOFF - offsetY\n" 

	theRotatExpression += "quat 0 0 sinVal  1\n"
	theRotatExpression += ")\n"
	theRotatExpression += "else\n"
	theRotatExpression += "(\n"
	theRotatExpression += "(quat 0 0 0 1)\n"
	theRotatExpression += ")\n"
	
	
	--theRotatExpression += "(quat 0 0 0 1)\n"
	
	-- thePosExpression
	
	rs.SetExpression (theRotatExpression)	
	
)



-------------------------------------------------------------------- Make ctrls  --------------------------------------------------------------------
function make_jelly_ctrls =
	(	
	newCtrl_list = #()
	newCtrl2_list = #()
	newCtrl3_list = #()

	mysel = getcurrentselection()


	for i in 1 to mysel.count  do 
	(
		obj = mysel[i]
		
		objName = obj.name + "_Sin_Ctrl" 
		newCtrl = circle name:objName radius:(5-(i*.25)) wirecolor:green steps:0 
		newCtrl.rotation = obj.rotation
		newCtrl.position = obj.position
		append newCtrl_list newCtrl
		
		objName = obj.name + "_Ctrl" 
		newCtrl2 = egg name:objName  wirecolor:yellow steps:6 outline:false length:(20- (i *1.5)) egg_angle:-90
		newCtrl2.objectOffsetPos = [6.5,0,0]	
		newCtrl2.rotation = obj.rotation
		newCtrl2.position = obj.position
		append newCtrl2_list newCtrl2
			
			
		objName = obj.name + "individual_Ctrl" 
		newCtrl3 = circle name:objName radius:(8.2-(i*.35)) wirecolor:red steps:6 
		newCtrl3.rotation = obj.rotation
		newCtrl3.position = obj.position
		append newCtrl3_list newCtrl3
			
		
		newCtrl.parent = newCtrl2
		newCtrl2.parent = newCtrl3
			
		if i > 1 then 
		(	
			newCtrl3.parent = newCtrl_list[i-1]
		)
		
	)	
)


make_jelly_ctrls()

print "fdfa"

MasterObject = $Box001

add_master_pulse_ctrl_attributes MasterObject
add_master_vis_ctrl_attributes MasterObject

$.parent = $JELLY_boneA_A_Sin_Ctrl

$JELLY_boneA_Aindividual_Ctrl
JELLY_boneA_A 
linkconstrint
JELLY_boneA_B_Sin_Ctrl
for obj in selection do
(
	mybone = substituteString  obj.name "_Sin_Ctrl" ""	
	mybone = getnodebyname mybone
	mybone.parent = obj
	--add_link_constraint obj mybone	
)


$JELLY_boneA_A =  

add_link_constraint $JELLY_boneA_Aindividual_Ctrl $JELLY_boneA_A 


function  add_link_constraint parent child = 
(	
	child.rotation.controller = rotation_list()
	oc = 	orientation_constraint()
	child.rotation.controller.Available.controller = oc
	--lc = child.controller = orientation_constraint() 
	oc.appendTarget parent 100
	oc.relative = true
	
	child.position.controller = position_list()
	pc = 	position_constraint()
	child.position.controller.Available.controller = pc
	--lc = child.controller = orientation_constraint() 
	pc.appendTarget parent 100
	pc.relative = true
	
)

function add_rotation_scriptController obj  =
(
	-- create a Position List controller for the position controller
	obj.rotation.controller = rotation_list()

	-- create a Position Script controller for the second Available position controller	& assign it
	oc = 	orientation_constraint()
	obj.rotation.controller.Available.controller = oc
	
	return oc
)



mysel = getcurrentselection()

for i in  mysel do 
(	
	add_sin_ctrl_attributes i
	rs = add_rotation_scriptController i
	rotation_script_controller_logic i MasterObject rs  
)

bob = getnodebyname "JELLY_boneA_B_Ctrl"
select bob

connecter
conneted

connecter = $
connected = substituteString  connecter.name "boneA" "boneB"
connected = getnodebyname connected


paramWire.connect2Way connecter[#transform][#rotation] connected[#transform][#rotation] "Rotation" "Rotation"
hide connected


connecter = $

for i in #( "boneB","boneC","boneD","boneE","boneF","boneG","boneH") do 
(
	connecter = $
	connected = substituteString  connecter.name "boneA" i
	connected = getnodebyname connected

	paramWire.connect2Way connecter[#transform][#rotation] connected[#transform][#rotation] "Rotation" "Rotation"
	hide connected
)


for i in #("A", "B", "C","D","E","F") do 
(	connecter = "JELLY_boneA_"+ i +"_Ctrl"
	connecter = getnodebyname connecter
	print connecter
	for j in #("B","C","D","E","F","G","H") do 
	(	conneted = "JELLY_bone"+ j +"_" + i +"_Ctrl"
		conneted = getnodebyname conneted
		if conneted != undefined and connecter != undefined then 
		(
			print conneted 
			paramWire.connect2Way connecter[#transform][#rotation] conneted[#transform][#rotation] "Rotation" "Rotation"
			hide conneted
		)
	)
)	



connecter = "JELLY_boneA_"+ "A" +"_Ctrl"
connecter = getnodebyname connecter
conneted = "JELLY_bone"+ "B" +"_" + "A" +"_Ctrl"
conneted = getnodebyname conneted
paramWire.connect2Way connecter[#transform][#rotation] conneted[#transform][#rotation] "Rotation" "Rotation"



upperLimb_Ctrl.modifiers[#AttributeHolder].IK_FK_Blend[#animationTrack] "Rotation" "Rotation"
$[#transform][#rotation]






for i in selection do 
(	
	xfm = xform()
	addModifier i xfm	
	paramWire.connect MasterObject[#Modified_Object][#Pulse_Attributes].vis_Attributes[#indivual_ctrls] \
	i.modifiers[#xform].gizmo[#scale] "[indivual_ctrls,indivual_ctrls,indivual_ctrls]"
)


for i in selection do 
(
	xfm = xform()
	addModifier i xfm	
	paramWire.connect MasterObject[#Modified_Object][#Pulse_Attributes].vis_Attributes[#indivual_wave] \
	i.modifiers[#xform].gizmo[#scale] "[indivual_wave,indivual_wave,indivual_wave]"
)



for i in selection do 
(
	i.modifiers[#Sin_Attributes].Sin_Attributes.amplitudeTrack = 0.2
	i.modifiers[#Sin_Attributes].Sin_Attributes.offsetYTrack = 0.1
)
for i in selection do 
(
	i.modifiers[#Sin_Attributes].Sin_Attributes.amplitudeTrack = 0.15
	i.modifiers[#Sin_Attributes].Sin_Attributes.timeOffSetTrack = 45
	i.modifiers[#Sin_Attributes].Sin_Attributes.offsetYTrack = 0.1
)
for i in selection do
(
	i.modifiers[#Sin_Attributes].Sin_Attributes.amplitudeTrack = 0.15
	i.modifiers[#Sin_Attributes].Sin_Attributes.timeOffSetTrack = 90
	i.modifiers[#Sin_Attributes].Sin_Attributes.offsetYTrack = 0.1
)
for i in selection do 
(
	i.modifiers[#Sin_Attributes].Sin_Attributes.amplitudeTrack = 0.3
	i.modifiers[#Sin_Attributes].Sin_Attributes.timeOffSetTrack = 120
	i.modifiers[#Sin_Attributes].Sin_Attributes.offsetYTrack = 0.1
)

for i in selection do 
(
	i.modifiers[#Sin_Attributes].Sin_Attributes.amplitudeTrack = 1
	i.modifiers[#Sin_Attributes].Sin_Attributes.timeOffSetTrack = 160
	i.modifiers[#Sin_Attributes].Sin_Attributes.offsetYTrack = 0.1
)




$[#transform][#link_params][#rotation].value
visibility
"    Space_Warps"
"    transform"
"        link_params"
"            position"
"                x_position"
"                y_position"
"                z_position"
"            rotation"
"                x_rotation"
"                y_rotation"
"                z_rotation"
"            scale"
"        Link_Times"


function add_position_scriptController obj  =
(
	-- create a Position List controller for the position controller
	obj.pos.controller = position_list()

	-- create a Position Script controller for the second Available position controller	& assign it
	ps = 	position_script()
	obj.pos.controller.Available.controller = ps
	
	return ps
)

function add_rotation_look_at_constraint obj  =
(
	-- create a Position List controller for the position controller
	obj.rotation.controller = rotation_list()

	-- create a Position Script controller for the second Available position controller	& assign it
	
	lc = 	lookat_constraint()
	obj.rotation.controller.Available.controller = lc
	
	return lc
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
			springAmpTrack type:#float UI:spring_amp_Spinner Default:1.00
		) 

		--The rollout that will show up in the modifier panel. 
		rollout params "Custom Attributes" 
		( 
			--The spinner that is connected to the animationTrack 
			spinner Time_Offset_Spinner "Time_Offset"  range:[-200,200,0]
			spinner spring_amp_Spinner "Spring Amp"  range:[0,2,1]
		) 
	) 
	
	-- Make an empty Modifier to hold the attribute	
	eM=emptyModifier() 
	eM.Name = "Time_Offset"
	addModifier obj eM 
	--Add the Time Offset Atter. to the Modifier :) 
	custAttributes.add eM TimeOffsetAtter;
)



function script_controller_logic_tentacles obj MasterObject ps= 
(	
	-- Assign a Node Variable to Script Controller: Master Box Transform Position
	ps.addNode "Master_Box" MasterObject

	-- Assign a Track Variable to the Script Controller: The objects "Time Offset" Atter.
	ps.addTarget "OffsetVal" MasterObject[#Modified_Object][#Time_Offset].Time_Offset[#animationTrack]
	ps.addTarget "amp" MasterObject[#Modified_Object][#Time_Offset].Time_Offset[#springAmpTrack]
	
	--  Create the expression string
	thePosExpression = "if Master_Box != undefined then\n"
	thePosExpression += "(\n"
	thePosExpression += "offsetValue = at time(currentTime - OffsetVal) Master_Box.position\n"
	thePosExpression += ("finalPos = offsetValue - " + MasterObject.position as string +"\n")
	thePosExpression += "amp = amp - 1\n" 
	thePosExpression += "differenceVector = offsetValue - Master_Box.position\n"
	thePosExpression += "diffScaled = differenceVector * amp\n"
	thePosExpression += "finalPos = finalPos + diffScaled \n" 
	thePosExpression += "finalPos\n" 
	
	thePosExpression += ")\n"
	thePosExpression += "else\n"
	thePosExpression += "(\n"
	thePosExpression += "[0,0,0]\n"
	thePosExpression += ")"
	-- thePosExpression
	ps.SetExpression (thePosExpression)	

)



(
	
function make_jelly_tentacles = 
(	
	mySel = getcurrentselection()
	parentBox = false 	
		
	for i in 1 to mySel.count  do 
	(	-- for i in bones 	
		if classof mySel[i] ==  BoneGeometry then 
		(	---- make point helpers
			---- one cross 
			
			if i == 1 then 
			(
				masterBox = point cross:on box:on centermarker:off name:(mySel[i].name +"_MASTER") wirecolor:red
				masterBox.rotation = mySel[i].rotation
				masterBox.pos = mySel[i].pos
				mySel[i].parent = masterBox
				parentBox = masterBox						
			)
			
			else 
			(
				myPoint = point cross:on box:off centermarker:off size:5 name:(mySel[i].name +"_Cross") wirecolor:blue
				myPoint.rotation = mySel[i].rotation	
				myPoint.pos = mySel[i].pos
				---- one box 
				myBox = point cross:off box:on centermarker:off size:20 name:(mySel[i].name +"_Box") wirecolor:green
				myBox.rotation = mySel[i].rotation
				myBox.pos = mySel[i].pos
				
				myTarget = point cross:off box:off centermarker:on size:20 name:(mySel[i].name +"_Target") wirecolor:yellow
				myTarget.rotation = mySel[i].rotation
				myTarget.pos = mySel[i].pos
				
				
				---- link boxes on to eacchother 
				if classof parentBox != UndefinedClass do
				(	myBox.parent = parentBox
				)
				
				---- link crosses on to bone below if it is the first time making a cross aka on the second bone then link it to the master box 
				if i == 2 then 
				(
					myPoint.parent = parentBox
				)		
				else 
				(	
					myPoint.parent = mySel[i-2]
				)
				
				--- add rotation list to Bone and add a look at controller to the rotation 
				lc = add_rotation_look_at_constraint mySel[i-1]
				--- add target 
				lc.appendTarget myTarget 100
				-- look at axis is X--- X:0 Y:2 Z:3
				lc.target_axis = 0
				lc.upnode_world = off
				lc.pickUpNode = myPoint
				lc.viewline_length_abs = off
				lc.lookat_vector_length = 0

				parentBox = myBox
				
				add_offset_attribute myBox
				ps = add_position_scriptController myTarget
				script_controller_logic_tentacles myTarget myBox ps
				
				myBox.modifiers[#Time_Offset].Time_Offset.animationTrack = (i-1)*2
				
				--cS
			)
		)
	)
)



$.sidefinssize = 2


$.sidefinsstarttaper = -3
$.sidefinsendtaper = 0.1

make_jelly_tentacles() 

add_offset_attribute myBox

obj = $
MasterObject = $


add_offset_attribute myTarget
ps = add_position_scriptController myTarget
script_controller_logic myTarget myBox ps






--- link bone parent to master? 

-- add link constrent to each bone pointed at box up vectore is cross 
)
)
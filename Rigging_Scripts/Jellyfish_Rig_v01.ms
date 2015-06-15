
function add_master_pulse_ctrl_attributes obj = 
(
	--- This Function creats a custom atter Time_Offset that is added to an
	--- empty modifier called Time Offest.  :) ---
	
	--Create the defintion for the custom attribute 
	Global_Pulse_Attribute = attributes Global_Pulse_Attribute
	(	--Parameter block to store the tracks of animation 
		parameters main rollout:pulseRollout
		( 	--A track of animation 
			--Look under scripted plugins for the types that can be used. 
			pulseTrack type:#float UI:pulse_Spinner Default:0.0
		) 
		--The rollout that will show up in the modifier panel. 
		rollout pulseRollout "Global Pulse" 
		( 	--The spinner that is connected to the animationTrack 
			spinner pulse_Spinner "Pulse"  range:[-9000000,9000000,0]
		) 
	) 
	
	
	Outter_Bell_Attributes = attributes Outter_Bell_Attributes 
	( 
		--Parameter block to store the tracks of animation 
		parameters main rollout:bellRollout
		( 	--A track of animation 
			--Look under scripted plugins for the types that can be used. 
			overAllAmpTrack type:#float UI:amp_Spinner Default:1.00
			vertical_BiasTrack type:#float UI:verticalBias_Spinner Default:0.0
			
		) 
		--The rollout that will show up in the modifier panel. 
		rollout bellRollout "Bell" 
		( 	--The spinner that is connected to the animationTrack 
			spinner amp_Spinner "Amp"  range:[0,100,1]
			spinner verticalBias_Spinner "Vertical Bias"  range:[-9000000,9000000,0]
		) 
	) 
	
	
	Vis_Attributes = attributes Vis_Attributes 
	( 
		--Parameter block to store the tracks of animation 
		parameters main rollout:visRollout
		( 	--A track of animation 
			--Look under scripted plugins for the types that can be used. 
			indivual_wave type:#float UI:indivual_wave_Spinner Default:1.0
			indivual_ctrls type:#float UI:indivual_ctrls_Spinner Default:0.0
			indivual_pulse type:#float UI:indivual_pulse_Spinner Default:0.0
			
			--inner_indivual_wave type:#float UI:inner_indivual_wave_Spinner Default:1.0
			--inner_indivual_ctrls type:#float UI:inner_indivual_ctrls_Spinner Default:1.0
			--inner_indivual_pulse type:#float UI:inner_indivual_pulse_Spinner Default:1.0
		) 
		--The rollout that will show up in the modifier panel. 
		rollout visRollout "Ctrl Vis." 
		( 	--The spinner that is connected to the animationTrack 
			spinner indivual_wave_Spinner "Pulse Vis"  range:[0,1,0]
			spinner indivual_ctrls_Spinner "Indv Ctrls Vis"  range:[0,1,0]
			spinner indivual_pulse_Spinner "Indv Pulse Vis"  range:[0,1,0]
			--spinner inner_indivual_wave_Spinner "Inner_Pulse Vis"  range:[0,1,0]
			--spinner inner_indivual_ctrls_Spinner "Inner_Indv Ctrls Vis"  range:[0,1,0]
			--spinner inner_indivual_pulse_Spinner "Inner_Indv Pulse Vis"  range:[0,1,0]
		) 
	) 
	
	
	--print Global_Pulse_Attribute
	-- Make an empty Modifier to hold the attribute	
	eM = emptyModifier() 
	eM.Name = "Bell_Attributes"
	addModifier obj eM 
	--Add the Time Offset Atter. to the Modifier :) 
	custAttributes.add eM Global_Pulse_Attribute
	custAttributes.add eM Outter_Bell_Attributes
	custAttributes.add eM Vis_Attributes
	
	--custAttributes.add obj.modifiers[#Bell_Attributes] Global_Pulse_Attributes;
	--custAttributes.add obj.modifiers[#Bell_Attributes] Outter_Bell_Attributes;
	--custAttributes.add obj.modifiers[#Bell_Attributes] Vis_Attributes;
)


function add_master_inenr_pulse_ctrl_attributes obj = 
(
	--- This Function creats a custom atter Time_Offset that is added to an
	--- empty modifier called Time Offest.  :) ---
	
	
	inner_Bell_Attributes = attributes inner_Bell_Attributes 
	( 
		--Parameter block to store the tracks of animation 
		parameters main rollout:bellRollout
		( 	--A track of animation 
			--Look under scripted plugins for the types that can be used. 
			overAllAmpTrack type:#float UI:amp_Spinner Default:1.00
			vertical_BiasTrack type:#float UI:verticalBias_Spinner Default:0.0
			
		) 
		--The rollout that will show up in the modifier panel. 
		rollout bellRollout "Bell" 
		( 	--The spinner that is connected to the animationTrack 
			spinner amp_Spinner "Amp"  range:[0,100,1]
			spinner verticalBias_Spinner "Vertical Bias"  range:[-9000000,9000000,0]
		) 
	) 
	
	
	Vis_Attributes = attributes Vis_Attributes 
	( 
		--Parameter block to store the tracks of animation 
		parameters main rollout:visRollout
		( 	--A track of animation 
			--Look under scripted plugins for the types that can be used. 
			indivual_wave type:#float UI:indivual_wave_Spinner Default:1.0
			indivual_ctrls type:#float UI:indivual_ctrls_Spinner Default:0.0
			indivual_pulse type:#float UI:indivual_pulse_Spinner Default:0.0
			
			--inner_indivual_wave type:#float UI:inner_indivual_wave_Spinner Default:1.0
			--inner_indivual_ctrls type:#float UI:inner_indivual_ctrls_Spinner Default:1.0
			--inner_indivual_pulse type:#float UI:inner_indivual_pulse_Spinner Default:1.0
		) 
		--The rollout that will show up in the modifier panel. 
		rollout visRollout "Ctrl Vis." 
		( 	--The spinner that is connected to the animationTrack 
			spinner indivual_wave_Spinner "Pulse Vis"  range:[0,1,0]
			spinner indivual_ctrls_Spinner "Indv Ctrls Vis"  range:[0,1,0]
			spinner indivual_pulse_Spinner "Indv Pulse Vis"  range:[0,1,0]
			--spinner inner_indivual_wave_Spinner "Inner_Pulse Vis"  range:[0,1,0]
			--spinner inner_indivual_ctrls_Spinner "Inner_Indv Ctrls Vis"  range:[0,1,0]
			--spinner inner_indivual_pulse_Spinner "Inner_Indv Pulse Vis"  range:[0,1,0]
		) 
	) 
	
	--print Global_Pulse_Attribute
	-- Make an empty Modifier to hold the attribute	
	eM = emptyModifier() 
	eM.Name = "Bell_Attributes"
	addModifier obj eM 
	--Add the Time Offset Atter. to the Modifier :) 
	--custAttributes.add eM Global_Pulse_Attribute
	custAttributes.add eM inner_Bell_Attributes
	custAttributes.add eM Vis_Attributes
	
	--custAttributes.add obj.modifiers[#Bell_Attributes] Global_Pulse_Attributes;
	--custAttributes.add obj.modifiers[#Bell_Attributes] Outter_Bell_Attributes;
	--custAttributes.add obj.modifiers[#Bell_Attributes] Vis_Attributes;
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
			phaseTrack type:#float UI:Phase_Spinner Default:0.00
			amplitudeTrack type:#float UI:Amplitude_Spinner Default:1
			vertical_BiasTrack type:#float UI:Vertical_Bias_Spinner Default:0.0
			
			ind_phaseTrack type:#float UI:ind_Phase_Spinner Default:0.00
			ind_amplitudeTrack type:#float UI:ind_Amplitude_Spinner Default:0.0
			ind_vertical_BiasTrack type:#float UI:ind_vertical_Bias_Spinner Default:0.0
			
			row_phaseTrack type:#float UI:row_Phase_Spinner Default:0.0
		) 

		--The rollout that will show up in the modifier panel. 
		rollout params "Custom Attributes" 
		( 
			--The spinner that is connected to the animationTrack 
			spinner Amplitude_Spinner "Amp" range:[0,100,1]
			spinner Phase_Spinner "Phase" range:[-5000,5000,0]
			spinner Vertical_Bias_Spinner "Vertical_Bias" range:[-500,500,0]
			spinner ind_Amplitude_Spinner "Amp_Offset" range:[0,100,0]
			spinner ind_Phase_Spinner "Phase_Offest" range:[-5000,5000,0]
			spinner ind_Vertical_Bias_Spinner "Vertical_Bias_Offset" range:[-500,500,0]
			spinner row_Phase_Spinner "Row_Phase_Offest" range:[-5000,5000,0]
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
--$[#Modified_Object][#Pulse_Attributes].Pulse_Attributes[#PulseTrack]
--$[#Modified_Object][#Bell_Attributes].Global_Pulse_Attribute[#PulseTrack]
--$[#Modified_Object][#Bell_Attributes].Outter_Bell_Attributes[#overAllAmpTrack]
--$[#Modified_Object][#Bell_Attributes].Outter_Bell_Attributes[#vertical_BiasTrack]	

function rotation_script_controller_logic obj MasterObject BellObject rs= 
(	
	-- Assign a Node Variable to Script Controller: Master Box Transform Position
	-- rs.addNode "Master_Box" MasterObject
	rs.addTarget "const" MasterObject[#Modified_Object][#Bell_Attributes].Global_Pulse_Attribute[#PulseTrack]
	rs.addTarget "overAllAmp" BellObject[#Modified_Object][#Bell_Attributes].Inner_Bell_Attributes[#overAllAmpTrack]
	rs.addTarget "vertBias" BellObject[#Modified_Object][#Bell_Attributes].Inner_Bell_Attributes[#vertical_BiasTrack]	
	
	-- Assign a Track Variable to the Script Controller: The objects "Time Offset" Atter.
	rs.addTarget "Offset_X" obj[#Modified_Object][#Sin_Attributes].Sin_Attributes[#phaseTrack]
	rs.addTarget "amplitude" obj[#Modified_Object][#Sin_Attributes].Sin_Attributes[#amplitudeTrack]
	rs.addTarget "offsetY" obj[#Modified_Object][#Sin_Attributes].Sin_Attributes[#vertical_BiasTrack]
	
	
	-- Assign a Track Variable to the Script Controller: The objects "Time Offset" Atter.
	rs.addTarget "ind_Offset_X" obj[#Modified_Object][#Sin_Attributes].Sin_Attributes[#ind_phaseTrack]
	rs.addTarget "ind_amplitude" obj[#Modified_Object][#Sin_Attributes].Sin_Attributes[#ind_amplitudeTrack]
	rs.addTarget "ind_offsetY" obj[#Modified_Object][#Sin_Attributes].Sin_Attributes[#ind_vertical_BiasTrack]
	
	rs.addTarget "row_amplitude" obj[#Modified_Object][#Sin_Attributes].Sin_Attributes[#row_phaseTrack]
	
	--  Create the expression string
	
	theRotatExpression = "if const != undefined then \n"
	theRotatExpression += "(\n"
		
	theRotatExpression +=  "Offset_X = Offset_X + ind_Offset_X\n"
	theRotatExpression +=  "amplitude = amplitude + ind_amplitude + row_amplitude\n"
	theRotatExpression +=  "offsetY = (offsetY + ind_offsetY + vertBias)/90\n"
	theRotatExpression += "myAmp = ((amplitude/10*overAllAmp/10))\n"
	
	theRotatExpression += "sinValOFF = (sin(0- offset_X)*myAmp)\n"
	theRotatExpression += "sinVal = ((sin(const- offset_X))*myAmp) - sinValOFF - offsetY\n" 

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


/*	rs = obj.rotation.controller[#Rotation_Script] 
	rs.addTarget "const" MasterObject[#Modified_Object][#Bell_Attributes].Global_Pulse_Attribute[#PulseTrack]
	rs.addTarget "overAllAmp" MasterObject2[#Modified_Object][#Pulse_Attributes].inner_Bell_Attributes[#overAllAmpTrack]
	rs.addTarget "vertBias" MasterObject2[#Modified_Object][#Pulse_Attributes].inner_Bell_Attributes[#vertical_BiasTrack]
	
	
	theRotatExpression = "if const != undefined then \n"
	theRotatExpression += "(\n"
	--theRotatExpression += "-- get sin OFFEST VALUE\n"
	--theRotatExpression +=  "overAllAmp = overAllAmp/10\n"
	--theRotatExpression +=  "amplitude = amplitude/10\n"
	--theRotatExpression +=  "ind_amplitude = ind_amplitude/10\n"
		
	theRotatExpression +=  "Offset_X = Offset_X + ind_Offset_X\n"
	theRotatExpression +=  "amplitude = amplitude + ind_amplitude\n"
	theRotatExpression +=  "offsetY = (offsetY + ind_offsetY + vertBias)/90\n"
	theRotatExpression += "myAmp = ((amplitude/10*overAllAmp/10))\n"
	
	theRotatExpression += "sinValOFF = (sin(0- offset_X)*myAmp)\n"
	--theRotatExpression += "-- calculate the value of the rotation\n"
	theRotatExpression += "sinVal = ((sin(const- offset_X))*myAmp) - sinValOFF - offsetY\n" 

	theRotatExpression += "quat 0 0 sinVal  1\n"
	theRotatExpression += ")\n"
	theRotatExpression += "else\n"
	theRotatExpression += "(\n"
	theRotatExpression += "(quat 0 0 0 1)\n"
	theRotatExpression += ")\n"
	
	--theRotatExpression += "(quat 0 0 0 1)\n"
	-- thePosExpression
	
	rs.SetExpression (theRotatExpression)	
*/ 

function exterior_bell_settings theSelection = 
(
	theSelection[1].modifiers[#Sin_Attributes].Sin_Attributes.amplitudeTrack = 20
	theSelection[1].modifiers[#Sin_Attributes].Sin_Attributes.vertical_BiasTrack = 0.0

	theSelection[2].modifiers[#Sin_Attributes].Sin_Attributes.amplitudeTrack = 15
	theSelection[2].modifiers[#Sin_Attributes].Sin_Attributes.phaseTrack = 40
	theSelection[2].modifiers[#Sin_Attributes].Sin_Attributes.vertical_BiasTrack = 0.0

	theSelection[3].modifiers[#Sin_Attributes].Sin_Attributes.amplitudeTrack = 15
	theSelection[3].modifiers[#Sin_Attributes].Sin_Attributes.phaseTrack = 80
	theSelection[3].modifiers[#Sin_Attributes].Sin_Attributes.vertical_BiasTrack = 0.0

	theSelection[4].modifiers[#Sin_Attributes].Sin_Attributes.amplitudeTrack = 40
	theSelection[4].modifiers[#Sin_Attributes].Sin_Attributes.phaseTrack = 125
	theSelection[4].modifiers[#Sin_Attributes].Sin_Attributes.vertical_BiasTrack = 0.0

	theSelection[5].modifiers[#Sin_Attributes].Sin_Attributes.amplitudeTrack = 60
	theSelection[5].modifiers[#Sin_Attributes].Sin_Attributes.phaseTrack = 135
	theSelection[5].modifiers[#Sin_Attributes].Sin_Attributes.vertical_BiasTrack = 0.0

	theSelection[6].modifiers[#Sin_Attributes].Sin_Attributes.amplitudeTrack = 20
	theSelection[6].modifiers[#Sin_Attributes].Sin_Attributes.phaseTrack = 160
	theSelection[6].modifiers[#Sin_Attributes].Sin_Attributes.vertical_BiasTrack = 0.0

	theSelection[7].modifiers[#Sin_Attributes].Sin_Attributes.amplitudeTrack = 12
	theSelection[7].modifiers[#Sin_Attributes].Sin_Attributes.phaseTrack = 170
	theSelection[7].modifiers[#Sin_Attributes].Sin_Attributes.vertical_BiasTrack = 0.0

	--theSelection[8].modifiers[#Sin_Attributes].Sin_Attributes.amplitudeTrack = 2.0
	--theSelection[8].modifiers[#Sin_Attributes].Sin_Attributes.phaseTrack = 175
	--theSelection[8].modifiers[#Sin_Attributes].Sin_Attributes.vertical_BiasTrack = 0.0
)

------------------------------------- interior -----------------------------
function interior_bell_settings theSelection = 
(
	theSelection[1].modifiers[#Sin_Attributes].Sin_Attributes.amplitudeTrack = 1.5
	theSelection[2].modifiers[#Sin_Attributes].Sin_Attributes.phaseTrack = -70

	theSelection[2].modifiers[#Sin_Attributes].Sin_Attributes.amplitudeTrack = 1.2
	theSelection[2].modifiers[#Sin_Attributes].Sin_Attributes.phaseTrack = -10
	theSelection[2].modifiers[#Sin_Attributes].Sin_Attributes.vertical_BiasTrack = 0.0

	theSelection[3].modifiers[#Sin_Attributes].Sin_Attributes.amplitudeTrack = 1.2
	theSelection[3].modifiers[#Sin_Attributes].Sin_Attributes.phaseTrack = 30
	theSelection[3].modifiers[#Sin_Attributes].Sin_Attributes.vertical_BiasTrack = 0.0

	theSelection[4].modifiers[#Sin_Attributes].Sin_Attributes.amplitudeTrack = 3
	theSelection[4].modifiers[#Sin_Attributes].Sin_Attributes.phaseTrack = 75
	theSelection[4].modifiers[#Sin_Attributes].Sin_Attributes.vertical_BiasTrack = 0.0


	theSelection[5].modifiers[#Sin_Attributes].Sin_Attributes.amplitudeTrack = 4
	theSelection[5].modifiers[#Sin_Attributes].Sin_Attributes.phaseTrack = 85
	theSelection[5].modifiers[#Sin_Attributes].Sin_Attributes.vertical_BiasTrack = 0.0


	theSelection[6].modifiers[#Sin_Attributes].Sin_Attributes.amplitudeTrack = 8
	theSelection[6].modifiers[#Sin_Attributes].Sin_Attributes.phaseTrack = 110
	theSelection[6].modifiers[#Sin_Attributes].Sin_Attributes.vertical_BiasTrack = 0.0


	theSelection[7].modifiers[#Sin_Attributes].Sin_Attributes.amplitudeTrack = 10
	theSelection[7].modifiers[#Sin_Attributes].Sin_Attributes.phaseTrack = 120
	theSelection[7].modifiers[#Sin_Attributes].Sin_Attributes.vertical_BiasTrack = 0.0

	theSelection[8].modifiers[#Sin_Attributes].Sin_Attributes.amplitudeTrack = 12.5
	theSelection[8].modifiers[#Sin_Attributes].Sin_Attributes.phaseTrack = 195
	theSelection[8].modifiers[#Sin_Attributes].Sin_Attributes.vertical_BiasTrack = 0.0


	--theSelection[9].modifiers[#Sin_Attributes].Sin_Attributes.amplitudeTrack = 20
	--theSelection[9].modifiers[#Sin_Attributes].Sin_Attributes.phaseTrack = 240
	--theSelection[9].modifiers[#Sin_Attributes].Sin_Attributes.vertical_BiasTrack = 0.0
)



-------------------------------------------------------------------- Make ctrls  --------------------------------------------------------------------
function make_jelly_ctrls masterObject bellObject =
	(	
	newCtrl_list = #()
	newCtrl2_list = #()
	newCtrl3_list = #()

	mysel = getcurrentselection()


	for i in 1 to mysel.count  do 
	(
		obj = mysel[i]
		
		objName = obj.name + "_Pulse_Ctrl" 
		newCtrl = circle name:objName radius:(.5-(i*.02)) wirecolor:green steps:0 
		newCtrl.rotation = obj.rotation
		newCtrl.position = obj.position
		append newCtrl_list newCtrl
		
		objName = obj.name + "_Ctrl" 
		newCtrl2 = egg name:objName  wirecolor:yellow steps:6 outline:false length:(1-(i*.01)) egg_angle:-90
		newCtrl2.objectOffsetPos = [(.5-(i*.01)),0,0]	
		newCtrl2.rotation = obj.rotation
		newCtrl2.position = obj.position
		append newCtrl2_list newCtrl2
			
			
		objName = obj.name + "_Individual_Ctrl" 
		newCtrl3 = circle name:objName radius:(.5-(i*.02)) wirecolor:red steps:6 
		newCtrl3.rotation = obj.rotation
		newCtrl3.position = obj.position
		append newCtrl3_list newCtrl3
			
		-- Egg Parent == sine 
		newCtrl2.parent = newCtrl
		-- Individual Parent == egg  		
		newCtrl3.parent = newCtrl2 
			
		if i > 1 then 
		(	--- sine parent = group abobe indivd  
			newCtrl.parent = newCtrl3_list[i-1]
		)
	
		
		--{POS_X,POS_Y,POS_Z,ROT_X,ROT_Y,ROT_Z,SCALE_X,SCALE_Y,SCALE_Z}.
		-- lock all pos rot and scale atters for sine ctrl 
		setTransformLockFlags newCtrl #{1,2,3,4,5,6,7,8,9}
		-- lock all pos and scale atters for ctr; 
		setTransformLockFlags newCtrl2 #{1,2,3,7,8,9} 
		
		-- lock all pos and scale atters for individual ctrl 
		setTransformLockFlags newCtrl3 #{1,2,3,7,8,9}
		--clearselection()
		--select newCtrl
		--macros.run "Animation Tools" "FreezeTransform"
		
		--clearselection()
		--select newCtrl2
		--macros.run "Animation Tools" "FreezeTransform"
		
		--clearselection()
		--select newCtrl3
		--macros.run "Animation Tools" "FreezeTransform"
	)

	mysel = newCtrl_list
	mysel3 = newCtrl3_list
	-- parent bones 
	for obj in mysel3 do
	(	mybone = substituteString  obj.name "_Individual_Ctrl" ""	
		mybone = getnodebyname mybone
		mybone.parent = obj
		--add_link_constraint obj mybone	
	)
	
	
	-- add scale xfrom to hide indivitual ctrls
	for i in mysel3 do 
	(	
		xfm = xform()
		addModifier i xfm	
		paramWire.connect bellObject[#Modified_Object][#Bell_Attributes].vis_Attributes[#indivual_ctrls] i.modifiers[#xform].gizmo[#scale] "[indivual_ctrls,indivual_ctrls,indivual_ctrls]"
	)

	-- add scale xfrom to hide sine ctrls
	for i in mysel do 
	(
		xfm = xform()
		addModifier i xfm	
	
		--paramWire.connect MasterObject[#Modified_Object][#Pulse_Attributes].vis_Attributes[#indivual_wave] \
		--i.modifiers[#xform].gizmo[#scale] "[indivual_wave,indivual_wave,indivual_wave]"

	)
	
	-- add sin atters 
	for i in mysel do 
	(	
		add_sin_ctrl_attributes i
		rs = add_rotation_scriptController i
		rotation_script_controller_logic i MasterObject bellObject rs  
	)

	
	interior_bell_settings mysel
)



function add_link_constraint parent child = 
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

/*

-- Define a Master 
MasterObject = $
BellObject = $
print "juli"

-- make master atters 
add_master_pulse_ctrl_attributes MasterObject
add_master_inenr_pulse_ctrl_attributes BellObject

--add_master_vis_ctrl_attributes MasterObject


-- Make Jelly Ctrls on selected bone hi
make_jelly_ctrls MasterObject BellObject


connecter = $
for str  in #("B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U") do 	
(
	connected = substituteString  connecter.name "A" str
	connected = getnodebyname connected
	if connected != undefined then 
	(
		-- connect individual ctrls 
		--paramWire.connect2way connected.transform.controller[#Rotation] connecter.rotation.controller[#Frozen_Rotation] "Frozen_Rotation" "Rotation"

		paramWire.connect2Way connecter[#transform][#rotation] connected[#transform][#rotation] "rotation" "Rotation"
		setTransformLockFlags connected #{1,2,3,4,5,6,7,8,9} 
		hide connected 
	)	
)


$[#transform][#rotation][#Zero_Euler_XYZ]

--- outter Bell 
MasterObject = $
connecter = $
for str  in #("B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U") do 	
(
	connected = substituteString  connecter.name "A" str
	connected = getnodebyname connected
	
	if connected != undefined then 
	(
		-- connect pulse controlles 
		paramWire.connect2Way connecter.modifiers[#Sin_Attributes].Sin_Attributes[#amplitudeTrack] \
		connected.modifiers[#Sin_Attributes].Sin_Attributes[#amplitudeTrack] "amplitudeTrack" "amplitudeTrack"

		paramWire.connect2Way connecter.modifiers[#Sin_Attributes].Sin_Attributes[#phaseTrack] \
		connected.modifiers[#Sin_Attributes].Sin_Attributes[#phaseTrack] "phaseTrack" "phaseTrack"

		paramWire.connect2Way connecter.modifiers[#Sin_Attributes].Sin_Attributes[#vertical_BiasTrack] \
		connected.modifiers[#Sin_Attributes].Sin_Attributes[#vertical_BiasTrack] "vertical_BiasTrack" "vertical_BiasTrack"
		
		paramWire.connect MasterObject[#Modified_Object][#Bell_Attributes].vis_Attributes[#indivual_pulse] \
		connected.modifiers[#xform].gizmo[#scale] "[indivual_pulse,indivual_pulse,indivual_pulse]"
	)
		
)

paramWire.connect MasterObject[#Modified_Object][#Bell_Attributes].vis_Attributes[#indivual_wave] \
$.modifiers[#xform].gizmo[#scale] "[indivual_wave,indivual_wave,indivual_wave]"








---- inner Bell part 
bellObject = $
connecter = $
for str  in #("B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U") do 	
(
	connected = substituteString  connecter.name "A" str
	connected = getnodebyname connected
	
	if connected != undefined then 
	(
		-- connect pulse controlles 
		paramWire.connect2Way connecter.modifiers[#Sin_Attributes].Sin_Attributes[#amplitudeTrack] \
		connected.modifiers[#Sin_Attributes].Sin_Attributes[#amplitudeTrack] "amplitudeTrack" "amplitudeTrack"

		paramWire.connect2Way connecter.modifiers[#Sin_Attributes].Sin_Attributes[#phaseTrack] \
		connected.modifiers[#Sin_Attributes].Sin_Attributes[#phaseTrack] "phaseTrack" "phaseTrack"

		paramWire.connect2Way connecter.modifiers[#Sin_Attributes].Sin_Attributes[#vertical_BiasTrack] \
		connected.modifiers[#Sin_Attributes].Sin_Attributes[#vertical_BiasTrack] "vertical_BiasTrack" "vertical_BiasTrack"
		
		paramWire.connect bellObject[#Modified_Object][#Bell_Attributes].vis_Attributes[#indivual_pulse] \
		connected.modifiers[#xform].gizmo[#scale] "[indivual_pulse,indivual_pulse,indivual_pulse]"
	)
		
)

paramWire.connect bellObject[#Modified_Object][#Bell_Attributes].vis_Attributes[#indivual_wave] \
$.modifiers[#xform].gizmo[#scale] "[indivual_wave,indivual_wave,indivual_wave]"





add_master_vis_ctrl_attributes $

showproperties $[#Modified_Object][#Bell_Attributes].vis_Attributes

MasterObject[#Modified_Object][#Bell_Attributes].vis_Attributes.ui
showproperties $[#Modified_Object][#Bell_Attributes].vis_Attributes

rollout 
MasterObject = $
getnodebyname "Fdf"

paramWire.connect MasterObject[#Modified_Object][#Bell_Attributes].vis_Attributes[#indivual_pulse] \
$.modifiers[#xform].gizmo[#scale] "[indivual_pulse,indivual_pulse,indivual_pulse]"

params


ANDREZ

indivual_wave type:#float UI:indivual_wave_Spinner Default:1.0
indivual_ctrls type:#float UI:indivual_ctrls_Spinner Default:0.0
indivual_pulse type:#float UI:indivual_pulse_Spinner Default:0.0
			
inner_indivual_wave type:#float UI:inner_indivual_wave_Spinner Default:1.0
inner_indivual_ctrls type:#float UI:inner_indivual_ctrls_Spinner Default:1.0
inner_indivual_pulse

mySel = getcurrentselection()

MasterObject = $
MasterObject2 = $

for obj in mySel do
(
/*	rs = obj.rotation.controller[#Rotation_Script] 
	rs.addTarget "const" MasterObject[#Modified_Object][#Bell_Attributes].Global_Pulse_Attribute[#PulseTrack]
	rs.addTarget "overAllAmp" MasterObject2[#Modified_Object][#Pulse_Attributes].inner_Bell_Attributes[#overAllAmpTrack]
	rs.addTarget "vertBias" MasterObject2[#Modified_Object][#Pulse_Attributes].inner_Bell_Attributes[#vertical_BiasTrack]
	
	
	theRotatExpression = "if const != undefined then \n"
	theRotatExpression += "(\n"
	--theRotatExpression += "-- get sin OFFEST VALUE\n"
	--theRotatExpression +=  "overAllAmp = overAllAmp/10\n"
	--theRotatExpression +=  "amplitude = amplitude/10\n"
	--theRotatExpression +=  "ind_amplitude = ind_amplitude/10\n"
		
	theRotatExpression +=  "Offset_X = Offset_X + ind_Offset_X\n"
	theRotatExpression +=  "amplitude = amplitude + ind_amplitude\n"
	theRotatExpression +=  "offsetY = (offsetY + ind_offsetY + vertBias)/90\n"
	theRotatExpression += "myAmp = ((amplitude/10*overAllAmp/10))\n"
	
	theRotatExpression += "sinValOFF = (sin(0- offset_X)*myAmp)\n"
	--theRotatExpression += "-- calculate the value of the rotation\n"
	theRotatExpression += "sinVal = ((sin(const- offset_X))*myAmp) - sinValOFF - offsetY\n" 

	theRotatExpression += "quat 0 0 sinVal  1\n"
	theRotatExpression += ")\n"
	theRotatExpression += "else\n"
	theRotatExpression += "(\n"
	theRotatExpression += "(quat 0 0 0 1)\n"
	theRotatExpression += ")\n"
	
	--theRotatExpression += "(quat 0 0 0 1)\n"
	-- thePosExpression
	
	rs.SetExpression (theRotatExpression)	
*/ 
	
/*	
	paramWire.connect MasterObject[#Modified_Object][#Bell_Attributes].vis_Attributes[#indivual_ctrls] \
	obj.modifiers[#xform].gizmo[#scale] "[indivual_ctrls,indivual_ctrls,indivual_ctrls]"
)

ANDREZ 
thesel = getcurrentselection()

for obj in thesel do
(
	rs = obj.position.controller[#Position_Script] 
	script = rs.script 
	rs.addTarget "Evaluate" $Klink_Global_Ctrl[#Modified_Object][#Attribute_Holder].custom_Attributes[#Evaluate__Center]

	--theNewScript  = substituteString script "if Master_Box != undefined then" "if Master_Box != undefined and Evaluate then"
	theNewScript  = substituteString script "amp = amp - 1" "--amp = amp - 1"
	theNewScript  = substituteString theNewScript "differenceVector = offsetValue - Master_Box.position" "--differenceVector = offsetValue - Master_Box.position"
	theNewScript  = substituteString theNewScript "diffScaled = differenceVector * amp" "--diffScaled = differenceVector * amp"
	theNewScript  = substituteString theNewScript "finalPos = finalPos + diffScaled" "--finalPos = finalPos + diffScaled"

	rs.SetExpression (theNewScript)	
)

string 
Shorty_*Pulse_Ctrl
.Rotation_List
rs.SetExpression (theRotatExpression

$[#Modified_Object][#Bell_Attributes].Global_Pulse_Attribute[#overAllAmpTrack]
ext

select $Shorty_outterBell_BoneD_05

select $Shorty_outterBell_BoneD_05_Individual_Ctrl
	
mysel = getcurrentselection()
for obj in mysel do 
(
	boneName = obj.name 
	myCtrlName =  boneName + "_Individual_Ctrl"
	
	try 	
	(	myCtrl = getnodebyname myCtrlName
		obj.parent = myCtrl
	)
	catch
	(
		print "poop"
	)
)


for i in selection do 
(
	myval = i.modifiers[#Sin_Attributes].Sin_Attributes.phaseTrack 
	newval = myval - 20
	myval = i.modifiers[#Sin_Attributes].Sin_Attributes.phaseTrack = newval
)

*/
-----------------------------------------------------------------------------------------------------------------------------
--------------------------------------------- Tentical Code ----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

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
			springAmpTrack type:#float UI:spring_amp_Spinner Default:0.25
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



--$.size = 2
function make_jelly_tentacles = 
(	
	mySel = getcurrentselection()
	parentBox = false 	
	masterBox = "" 	
	for i in 1 to mySel.count  do 
	(	-- for i in bones 	
		if classof mySel[i] ==  BoneGeometry then 
		(	---- make point helpers
			---- one cross 
			
			if i == 1 then 
			(
				masterBox = point cross:on box:on centermarker:off size:.5 name:(mySel[i].name +"_MASTER") wirecolor:red
				masterBox.rotation = mySel[i].rotation
				masterBox.pos = mySel[i].pos
				mySel[i].parent = masterBox
				parentBox = masterBox						
			)
			
			else 
			(
				myPoint = point cross:on box:off centermarker:off size:.5 name:(mySel[i].name +"_Cross") wirecolor:blue
				myPoint.rotation = mySel[i].rotation	
				myPoint.pos = mySel[i].pos
				---- one box 
				myBox = point cross:off box:on centermarker:off size:.5 name:(mySel[i].name +"_Box") wirecolor:green
				myBox.rotation = mySel[i].rotation
				myBox.pos = mySel[i].pos
				
				myTarget = point cross:off box:off centermarker:on size:.5 name:(mySel[i].name +"_Target") wirecolor:yellow
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
				
				myBox.modifiers[#Time_Offset].Time_Offset.animationTrack = (i-2)
				
				--cS
			)
		)
	)
	return masterBox
)



function make_a_spline_on_jointChain =
(
	pos_array = #()
	joints = getcurrentSelection()
	for i in joints do 
	(
		append pos_array i.pos 
	)


	ss = SplineShape pos:pos_array[1]
	addNewSpline ss
	for i in pos_array do
	(
		addKnot ss 1 #corner #line i
		--addKnot ss 1 #corner #line PointB
	)
	 updateShape ss
	
	return ss
)


function create_splineIK_superSpring = 
(	seleceted_slpineCtrls = getcurrentSelection()
	i = 1 
	for ctrl in seleceted_slpineCtrls do
	(	-- Create a point helper at position of ctre
		myPoint = circle radius:5 name:(ctrl.name + "_spIK_Ctrl") 
		myPoint.pos = ctrl.pos
		
		-- add xfrom modifier to ctrl for placement 
		xfm = xform()
		addModifier myPoint xfm	
		
		
		-- Add offest attributes to the point helper
		add_offset_attribute myPoint
		-- Add a script controller to the ctrl
		ps = add_position_scriptController ctrl
		-- Add script logic to the ctrl 
		script_controller_logic_tentacles ctrl myPoint ps	
		
		-- Set value of time offset
		myPoint.modifiers[#Time_Offset].Time_Offset.animationTrack = (i-1)*3
		
		i+=1 
	)
)

/*

print "poop"
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




$.size = 3

--- link bone parent to master? 

-- add link constrent to each bone pointed at box up vectore is cross 
)
)
dog = getcurrentSelection()
make_a_spline_on_jointChain()
-- Do some magic
---> create a spline ik on the joint chain and then add the super spring
--


make_a_spline_on_jointChain()
create_splineIK_superSpring()

$.size = 1.5

$.radius = 3
myTarget = $
myBox = $ 

add_offset_attribute myBox
ps = add_position_scriptController myTarget
script_controller_logic_tentacles myTarget myBox ps

--spIK = splineiksolver() 


select $.baseObject.faces[#{8037..16244}]
d




*/

masterKnubGeo = $knub_geo
mybones = #($MainBone_A, $MainBone_B, $MainBone_C, $MainBone_D)


curSel = getcurrentselection()

-- duplacate geoNub
newKnub = copy masterKnubGeo
--- duplacate already created bones 
maxOps.CloneNodes mybones expandHierarchy:true clonetype:#copy newNodes:&newnode
newnode

curSel = curSel[1]

--- add materal modifier 
material_modifier = Materialmodifier()
addModifier newKnub material_modifier



--- add skin modifiers
skin_modifier = skin() 
addModifier newKnub skin_modifier


-- curSel.modifiers 

balloonGeo = curSel.children[1] 

material_modifier.materialID = balloonGeo.modifiers[#Material].materialID 
newKnub.material = balloonGeo.material 



select newKnub

skinOps.addbone skin_modifier newnode[1] 0
skinOps.addbone skin_modifier newnode[2] 0
skinOps.addbone skin_modifier newnode[3] 1


select newnode
masterCtrl  = make_jelly_tentacles() 



masterCtrl.rotation = curSel.rotation 
masterCtrl.pos = curSel.pos

in coordsys local rotate masterCtrl (EulerAngles 0 90 0)
--in coordsys local  masterCtrl.scale += curSel[1].scale
masterCtrl.scale = curSel.scale
in coordsys local  masterCtrl.pos  += [12,0,0] 

masterCtrl.parent = curSel


select masterCtrl

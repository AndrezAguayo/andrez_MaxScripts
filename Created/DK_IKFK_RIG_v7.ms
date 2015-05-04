----------------------------------------------------------------------------------------------------------------------------------------------------
-- General Rigging Functions  
----------------------------------------------------------------------------------------------------------------------------------------------------
function make_rigging_hierarchy suffexName = 
(	
	rigGrp = PointHelperObj box:off cross:off axistripod:off centermarker:off size:20 name:(suffexName +"_Rig_Grp")
	geoGrp = PointHelperObj box:off cross:off axistripod:off centermarker:off size:20 name:(suffexName +"_Geo_Grp")
	bonesGrp = PointHelperObj box:off cross:off axistripod:off centermarker:off size:20 name:(suffexName +"_Bones_Grp")
	ctrlsGrp = PointHelperObj box:off cross:off axistripod:off centermarker:off size:20 name:(suffexName +"_Ctrls_Grp")	
	scaleGrp = PointHelperObj box:off cross:off axistripod:off centermarker:off size:20 name:(suffexName + "_Extra_toScale_Grp")
	noScaleGrp = PointHelperObj box:off cross:off axistripod:off centermarker:off size:20 name:(suffexName + "_Extra_noScale_Grp")
	
	geoGrp.parent = rigGrp	
	bonesGrp.parent = rigGrp
	ctrlsGrp.parent = rigGrp
	scaleGrp.parent = rigGrp
	noScaleGrp.parent = rigGrp

	return #(rigGrp, geoGrp, bonesGrp, ctrlsGrp, scaleGrp, noScaleGrp)
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


function add_vis_scriptController obj  =
(
	-- create a Position List controller for the position controller
	obj.rotation.controller = rotation_list()

	-- create a Position Script controller for the second Available position controller	& assign it
	oc = 	orientation_constraint()
	obj.rotation.controller.Available.controller = oc
	
	return oc
)


function  add_link_constraint parent child = 
(	
	lc = child.controller = link_constraint() 
	lc.addTarget parent 100
)




function limb_name_extractor limbType = 
(
	if limbType == "Arm" then
	(
		nameA = "UpperArm"
		nameB = "LowerArm"
		nameC = "Wrist"
		nameD = "Arm"
	)
	else
	(
		nameA = "UpperLeg"
		nameB = "LowerLeg"
		nameC = "Ankle"
		nameD = "Leg"
	)

	return #(nameA,nameB,nameC,nameD)
)


function add_empty_modifier_on_object myObject = 
(
	eM = emptyModifier() 
	addModifier myObject eM 
)

-- define function for rotating only the pivot point
function RotatePivotOnly obj myrotation = 
(
	local rotValInv=inverse(myrotation as quat)
	animate off in coordsys local obj.rotation*=rotValInv
	obj.objectoffsetpos*=rotValInv
	obj.objectoffsetrot*=rotValInv
)







function make_standard_2d_ctrl type myName = 
(	-- Make the Name of the Controler 
	theName = myName +"_Ctrl"
	-- Creat the Circle 
	if type == "Circle" then
	(	
		theCtrl = circle name:theName steps:5 radius:1.5 render_displayRenderMesh:false render_viewport_thickness:.01 render_thickness:.01
		theCtrl.objectoffsetrot =   (EulerAngles 90 0 0)
	)
	else if type == "Diamond" then
	(
		theCtrl = circle name:theName steps:0 radius:1.5 render_displayRenderMesh:false render_viewport_thickness:.01 render_thickness:.01
		theCtrl.objectoffsetrot =   (EulerAngles 90 0 0)
	)
	else if type == "Rectangle" then
	(		
		theCtrl = Rectangle name:theName length:2 width:2 render_displayRenderMesh:false render_viewport_thickness:.01 render_thickness:.01
		theCtrl.objectoffsetrot =   (EulerAngles 90 0 0)
	)
	else
	(
		print "The type "+ type as string +"is not a vald argument for funciton make_standard_2d_ctrl"
	)
	-- Add the Image Switch attrabute  
	--add_image_spinner theCtrl

	return theCtrl
)


----------------------------------------------------------------------------------------------------------------------------------------------------
-- Bone  Functions  
----------------------------------------------------------------------------------------------------------------------------------------------------
function createEnd selectedBone = 
(	
	parentBone = selectedBone
	parentTrans = parentBone.transform
	parentPos = parentTrans.translation
	 
	newBone = undefined  
	with redraw off 
	(
		newBone = BoneSys.createBone parentPos (parentPos+1) parentBone.dir
		newBone.transform = parentTrans
		in coordSys Local move newBone [parentBone.length,0,0]

		newBone.parent	= parentBone
		--? 
		--putChildIntoAssembly newBone

		newBone.width	= parentBone.width
		newBone.height	= parentBone.height
		newBone.taper	= 90
		newBone.length	= (parentBone.width+parentBone.height)/2
		newBone.wirecolor = parentBone.wirecolor
	)
	redrawViews()
	return newBone
)


function create_limb_bone_chain positionA positionB positionC extraSuffex BoneNameA BoneNameB BoneNameC boneGrp boneColor = 
(	-- will create a limb system for you. 
	-- extraSuffex = "FK"
	-- side = "l"
	--limbNames = limb_name_extractor limbType
	--BoneNameA = limbNames[1]
	--BoneNameB = limbNames[2]
	--BoneNameC = limbNames[3]
	

	boneA = BoneSys.createBone positionA positionB [0,0,1]   
	boneB = BoneSys.createBone positionB positionC [0,0,1]   
	boneC = createEnd boneB

	boneB.parent = boneA

	boneC.parent = boneB

	boneA.name = BoneNameA + "_" +  extraSuffex + "_Bone"
	boneB.name = BoneNameB + "_" +  extraSuffex + "_Bone"
	boneC.name = BoneNameC + "_" +  extraSuffex + "_Bone"

	boneA.width = .5
	boneA.height = .5
	boneB.width = .5
	boneB.height = .5
	boneC.width = .5
	boneC.height = .5

	boneA.wirecolor = boneColor
	boneB.wirecolor = boneColor
	boneC.wirecolor = boneColor
	
	boneA.parent = boneGrp

	
	return #(boneA, boneB, boneC)
)



----------------------------------------------------------------------------------------------------------------------------------------------------
-- IK FK  Functions  
----------------------------------------------------------------------------------------------------------------------------------------------------






function addChildren obj hierarchy = 
(	-- add object to the array 
	append hierarchy obj
	-- loop iver children and recursively add the children 
	for child in obj.children do 
		addChildren child hierarchy
	return hierarchy 
)



function add_oriention_constraint_to_bind_bones bindBone ikBone fkBone = 
(
	-- set some shit up! 
	bindBone.rotation.controller = rotation_list()
	orientCtrl = orientation_constraint()
	bindBone.rotation.controller.Available.controller = orientCtrl

	orientCtrl.appendTarget ikBone 50.0
	orientCtrl.appendTarget fkBone 50.0
)




function add_atters_IK_FK obj = 
--- Create a custom atter --- 
(
	--Create the defintion for the custom attribute 
	myAtter = attributes IK_FK_Blend
	( 
		
	--Parameter block to store the tracks of animation 
	parameters testP rollout:testR 
		( 
			
		--A track of animation 
		--Look under scripted plugins for the types that can be used. 
		animationTrack type:#float UI:ik_fk_BlendSpinner 
			
		
		--animationTrack type:#integer UI:imageSwitchSpinner 	
			
		) 

		--The rollout that will show up in the modifier panel. 
		rollout testR "IK and FK Attributes" 
		(
			
		--The spinner that is connected to the animationTrack 
		spinner ik_fk_BlendSpinner "IK_FK_Blend" type:#float range:[0,100,0]
		button niceRack "Match IK --> FK" pos:[5,30] width:150 height:40 tooltip:"Match the position of the IK Ctrls to the FK Ctrls"
		button veryNiceRack "Match FK <-- IK" pos:[5,80] width:150 height:40 tooltip:"Match the position of the FK Ctrls to the IK Ctrls"
		--spinner mySpinner "Image_Switch" type:#integer range:[1,20,1]
		
		on niceRack pressed do 
		(
			print "hello you cooco"
		)
		) 	
	) 
	
	--eM=emptyModifier() 
	--addModifier obj eM 
	--Add the definition to the emptyModifier 
	--custAttributes.add eM myAtter;
	
	custAttributes.add obj.modifiers[#AttributeHolder] myAtter;
)


function add_atters_Main_switch obj = 
--- Create a custom atter --- 
(
	--Create the defintion for the custom attribute 
	myAtter = attributes poseSwitch
	( 
		
		--Parameter block to store the tracks of animation 
		parameters testP rollout:testR 
		( 
		--A track of animation 
		--Look under scripted plugins for the types that can be used. 
		animationTrack type:#integer UI:poseSwitchsSpinner 
			
		) 

		--The rollout that will show up in the modifier panel. 
		rollout testR "Pose Switcher" 
		(
			--The spinner that is connected to the animationTrack 
			--button test "myButt"
			spinner poseSwitchsSpinner "Pose Switchs" type:#integer range:[1,100,1]
			---slider poseSwitchsSpinner2 "spinn2" type:#integer range:[0,100,0]
			button IsolateBtn "Isolate Current Pose"
			
			on IsolateBtn pressed do
			( 
				for i in selection do
				(
					hide_all_noncurrent_ctrls i
				)
			)
		) 	
	) 
	

	custAttributes.add obj.modifiers[#AttributeHolder] myAtter;
	
	obj[#Modified_Object][#Attribute_Holder].poseSwitch[#animationTrack].value = 1
	
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

function add_position_scriptController obj  =
(
	-- create a Position List controller for the position controller
	obj.pos.controller = position_list()

	-- create a Position Script controller for the second Available position controller	& assign it
	pc = 	position_constraint()
	obj.pos.controller.Available.controller = pc
	
	return pc
)



/*
function script_controller_logic obj MasterObject ss poseNumber = 
(	
	-- Assign a Node Variable to Script Controller: Master Box Transform Position
	ss.addNode "MainCtrl" MasterObject

	-- Assign a Track Variable to the Script Controller: The objects "Time Offset" Atter.
	ss.addTarget "poseSlider" MasterObject[#Modified_Object][#Attribute_Holder].poseSwitch[#animationTrack]

	--  Create the expression string
	theScalExpression = "if poseSlider == "+ poseNumber as string +" then\n"
	theScalExpression += "(\n"
	theScalExpression += "val = [1,1,1]\n"
	theScalExpression += ")\n"
	theScalExpression += "else\n"
	theScalExpression += "(\n"
	theScalExpression += "val = [0,0,0]\n"
	theScalExpression += ")\n"
	theScalExpression += "val"
	-- thePosExpression
	ss.SetExpression (theScalExpression)	

)
*/


function float_script_logic obj MasterObject poseNumber = 
(
	fl = float_list()
	fs = float_script() 
	obj.visibility = fl
	obj.visibility.controller = fs
	
	
	fs.addNode "MainCtrl" MasterObject
	fs.addTarget "poseSlider" MasterObject[#Modified_Object][#Attribute_Holder].poseSwitch[#animationTrack]
	
	--  Create the expression string
	theScalExpression = "if poseSlider == "+ poseNumber as string +" then\n"
	theScalExpression += "(\n"
	theScalExpression += "val = 1\n"
	theScalExpression += ")\n"
	theScalExpression += "else\n"
	theScalExpression += "(\n"
	theScalExpression += "val = 0\n"
	theScalExpression += ")\n"
	theScalExpression += "val"
	-- thePosExpression
	fs.SetExpression (theScalExpression)		

	
	--obj.visibility = fs

)



function script_controller_logic obj MasterObject ss poseNumber = 
(	
	-- Assign a Node Variable to Script Controller: Master Box Transform Position
	ss.addNode "MainCtrl" MasterObject

	-- Assign a Track Variable to the Script Controller: The objects "Time Offset" Atter.
	ss.addTarget "poseSlider" MasterObject[#Modified_Object][#Attribute_Holder].poseSwitch[#animationTrack]

	--  Create the expression string
	theScalExpression = "if poseSlider == "+ poseNumber as string +" then\n"
	theScalExpression += "(\n"
	theScalExpression += "val = [0,0,0]\n"
	theScalExpression += ")\n"
	theScalExpression += "else\n"
	theScalExpression += "(\n"
	theScalExpression += "val = [0,0,-50000]\n"
	theScalExpression += ")\n"
	theScalExpression += "val"
	-- thePosExpression
	ss.SetExpression (theScalExpression)	

)




function set_up_ikBones ikBones BoneNameA BoneNameB BoneNameC ctrlGrp =  
(
	--limbNames = limb_name_extractor limbType
	
	--limbNameC = limbNames[3]
	--limbNameD = limbNames[4]
	
	
	
	--- IK controller set up braaaaaaaa
	
	ikChain = IKSys.ikChain ikBones[1] ikBones[3] "IKHISolver" 
	ikChainName = BoneNameC + "_ik_solver"
	ikChain.name = ikChainName

	ikCtrlName = BoneNameC + "_Ik"
	ikCtrl = make_standard_2d_ctrl "Rectangle" ikCtrlName
	ikCtrl.wirecolor = green 
	--ikCtrl = circle  steps:0 render_displayRenderMesh:true sides:17 radius:50 name:"Ik_Ctrl" wirecolor:green

	ikCtrl.transform = ikBones[3].transform 
	--ikCtrl.position = boneC_IK.position

	ikChain.parent = ikCtrl

	-- Add List Rotation + orientation_constraint to Ik wrist joint 
	ikBones[3].rotation.controller = rotation_list()
	orientCtrl = orientation_constraint()
	ikBones[3].rotation.controller.Available.controller = orientCtrl
	orientCtrl.appendTarget ikCtrl 100.0
	
	-- create and Ik elbow ctrl poleVector
	--pvCtrl = circle  steps:1 render_displayRenderMesh:true sides:17 radius:50 name:"Ik_PV_Ctrl" wirecolor:green
	PV = FALSE 
	pvCtrl = undefined 
	if PV then
	(
		pvCtrlName =   BoneNameD + "_" + side + "_PV"
		pvCtrl = make_standard_2d_ctrl "Diamond" pvCtrlName
		pvCtrl.wirecolor = green 
		
		pvCtrl.transform = ikBones[2].transform
		
		-- add pole vececor crl as a rotation target  
		ikChain.transform.controller.VHTarget = pvCtrl
	)
	
	
	ikCtrl.parent = ctrlGrp  
	-- pvCtrl.parent = ctrlGrp
	
	return #(ikCtrl, pvCtrl)
)



function set_up_fkBones fkBones BoneNameA BoneNameB BoneNameC ctrlGrp =  
(
	--limbNames = limb_name_extractor limbType
	--limbNameA = limbNames[1]
	--limbNameB = limbNames[2]
	--limbNameC = limbNames[3]
	--limbNameD = limbNames[4]
	
	--suffexName = limbType + "_" + side
	
	------- FK Set up 
	--upperLimb_CtrlName = BoneNameA + "_" + side 
	upperLimb_Ctrl = make_standard_2d_ctrl "Circle" BoneNameA
	upperLimb_Ctrl.wirecolor = red
	--upperLimb_Ctrl = circle  steps:3 render_displayRenderMesh:true sides:17 radius:50 name:"upperLimb_Ctrl" wirecolor:red
	upperLimb_Ctrl.rotation = fkBones[1].rotation 
	upperLimb_Ctrl.position = fkBones[1].position

	--lowerLimb_CtrlName = limbNameB + "_" + side 
	lowerLimb_Ctrl = make_standard_2d_ctrl "Circle" BoneNameB
	lowerLimb_Ctrl.wirecolor = red
	--lowerLimb_Ctrl = circle  steps:3 render_displayRenderMesh:true sides:17 radius:50 name:"lowerLimb_Ctrl" wirecolor:red
	lowerLimb_Ctrl.rotation = fkBones[2].rotation 
	lowerLimb_Ctrl.position = fkBones[2].position

	--handLimb_CtrlName = limbNameC + "_" + side 
	hand_Ctrl = make_standard_2d_ctrl "Circle" BoneNameC
	hand_Ctrl.wirecolor = red
	--hand_Ctrl = circle  steps:3 render_displayRenderMesh:true sides:17 radius:50 name:"handLimb_Ctrl" wirecolor:red
	hand_Ctrl.rotation = fkBones[3].rotation 
	hand_Ctrl.position = fkBones[3].position


	-- Add list rotation and position ctrl to fk joints 
	fkBones[1].rotation.controller = rotation_list()
	orientCtrl = orientation_constraint()
	fkBones[1].rotation.controller.Available.controller = orientCtrl
	orientCtrl.appendTarget upperLimb_Ctrl 100.0

	fkBones[1].position.controller = position_list()
	positionCtrl = position_constraint()
	fkBones[1].position.controller.Available.controller = positionCtrl
	positionCtrl.appendTarget upperLimb_Ctrl 100.0


	fkBones[2].rotation.controller = rotation_list()
	orientCtrl = orientation_constraint()
	fkBones[2].rotation.controller.Available.controller = orientCtrl
	orientCtrl.appendTarget lowerLimb_Ctrl 100.0

	fkBones[2].position.controller = position_list()
	positionCtrl = position_constraint()
	fkBones[2].position.controller.Available.controller = positionCtrl
	positionCtrl.appendTarget lowerLimb_Ctrl 100.0


	fkBones[3].rotation.controller = rotation_list()
	orientCtrl = orientation_constraint()
	fkBones[3].rotation.controller.Available.controller = orientCtrl
	orientCtrl.appendTarget hand_Ctrl 100.0

	fkBones[3].position.controller = position_list()
	positionCtrl = position_constraint()
	fkBones[3].position.controller.Available.controller = positionCtrl
	positionCtrl.appendTarget hand_Ctrl 100.0

	hand_Ctrl.parent = lowerLimb_Ctrl
	lowerLimb_Ctrl.parent = upperLimb_Ctrl
	
	-- parent in to proper group 
	upperLimb_Ctrl.parent = ctrlGrp
	--lowerLimb_Ctrl.parnet = ctrlGrp
	--hand_Ctrl.parent = ctrlGrp
	
	return #(upperLimb_Ctrl, lowerLimb_Ctrl, hand_Ctrl)
	
)





function make_limb_setup objectA objectB objectC rigGroups = 
(
	
	rigGrp = rigGroups[1]
	geoGrp = rigGroups[2]
	bonesGrp = rigGroups[3]
	ctrlsGrp = rigGroups[4]
	scaleGrp = rigGroups[5]
	noScaleGrp = rigGroups[6]  
	
	-- Create Bones 
	--create_limb_bone_chain positionA positionB positionC  extraSuffex BoneNameA BoneNameB BoneNameC boneColor
	
	-- positionA positionB positionC BoneNameA BoneNameB BoneNameC
	prefix_A = substituteString objectA.name "_Geo" ""
	prefix_B  = substituteString objectB.name "_Geo" ""
	prefix_C  = substituteString objectC.name "_Geo" ""
	
	fkBones = create_limb_bone_chain objectA.position objectB.position objectC.position "FK" prefix_A prefix_B prefix_C bonesGrp Red
	ikBones = create_limb_bone_chain objectA.position objectB.position objectC.position "IK" prefix_A prefix_B prefix_C bonesGrp Green
	bindBones = create_limb_bone_chain objectA.position objectB.position objectC.position "Bind" prefix_A prefix_B prefix_C bonesGrp Gray




	-- setup bone blend 
	for i in 1 to 3 do 
	(	
		add_oriention_constraint_to_bind_bones bindBones[i] ikBones[i] fkBones[i]
		paramWire.connect bindBones[i][#transform][#rotation][#Orientation_Constraint][#Orientation_Weight_0]\
		bindBones[i][#transform][#rotation][#Orientation_Constraint][#Orientation_Weight_1] "100-Orientation_Weight_0"
	)


	-- setup IK bones  
	ikControles = set_up_ikBones ikBones prefix_A prefix_B prefix_C ctrlsGrp

	-- setup FK bones  
	fkControles = set_up_fkBones fkBones prefix_A prefix_B prefix_C ctrlsGrp

	ikCtrl = ikControles[1]
	-- ik_pvCtrl = ikControles[2]

	upperLimb_Ctrl = fkControles[1]
	lowerLimb_Ctrl = fkControles[2]
	hand_Ctrl = fkControles[3]


	---------------------------------
	-- set up ikfk blend atter on to the IK ctrl
	add_empty_modifier_on_object ikCtrl
	add_atters_IK_FK ikCtrl
	for i in 1 to 3 do 
	(	
		paramWire.connect ikCtrl.modifiers[#AttributeHolder].IK_FK_Blend[#animationTrack]\  
		bindBones[i][#transform]	[#rotation][#Orientation_Constraint][#Orientation_Weight_0] "animationTrack"
	)

	--------------------------------

	-- add atter to extra ctrls and 2way connect the atters together
	
	--add_empty_modifier_on_object ik_pvCtrl
	--add_atters_IK_FK ik_pvCtrl
	--paramWire.connect2Way ikCtrl.modifiers[#AttributeHolder].IK_FK_Blend[#animationTrack]\ 
	--ik_pvCtrl.modifiers[#AttributeHolder].IK_FK_Blend[#animationTrack] "animationTrack" "animationTrack"
	
	add_empty_modifier_on_object upperLimb_Ctrl
	add_atters_IK_FK upperLimb_Ctrl
	paramWire.connect2Way ikCtrl.modifiers[#AttributeHolder].IK_FK_Blend[#animationTrack]\ 
	upperLimb_Ctrl.modifiers[#AttributeHolder].IK_FK_Blend[#animationTrack] "animationTrack" "animationTrack"

	add_empty_modifier_on_object lowerLimb_Ctrl
	add_atters_IK_FK lowerLimb_Ctrl
	paramWire.connect2Way ikCtrl.modifiers[#AttributeHolder].IK_FK_Blend[#animationTrack]\ 
	lowerLimb_Ctrl.modifiers[#AttributeHolder].IK_FK_Blend[#animationTrack] "animationTrack" "animationTrack"

	add_empty_modifier_on_object hand_Ctrl
	add_atters_IK_FK hand_Ctrl
	paramWire.connect2Way ikCtrl.modifiers[#AttributeHolder].IK_FK_Blend[#animationTrack]\ 
	hand_Ctrl.modifiers[#AttributeHolder].IK_FK_Blend[#animationTrack] "animationTrack" "animationTrack"
		

	bone_master = point centermarker:false  axistripod:false  cross:false box:false name:(prefix_A +"_BoneMaster") size:1 
	ctrl_master = point centermarker:false  axistripod:false  cross:false box:false name:(prefix_A +"_CtrlMaster") size:2  
	limb_master = point centermarker:false  axistripod:false  cross:false box:true name:(prefix_A +"_Master") size:5  

	limb_master.position = bindBones[1].position
	ctrl_master.position = bindBones[1].position
	bone_master.position = bindBones[1].position
	
	
	limb_master.parent = ctrlsGrp
	
	bone_master.parent = bonesGrp 
	ctrl_master.parent = ctrlsGrp 
	
	ikBones[1].parent = bone_master
	bindBones[1].parent = bone_master
	
	upperLimb_Ctrl.parent = ctrl_master
	
	pc = add_position_scriptController bone_master
	oc = add_rotation_scriptController bone_master 
	
	
	pc.appendTarget limb_master 100
	pc.relative = true
	
	oc.appendTarget limb_master 100
	oc.relative = true
	
	pc = add_position_scriptController ctrl_master
	oc = add_rotation_scriptController ctrl_master 
	
	pc.appendTarget limb_master 100
	pc.relative = true
	
	oc.appendTarget limb_master 100
	oc.relative = true
	
	
	objectA.parent = geoGrp
	objectB.parent = geoGrp
	objectC.parent = geoGrp	
	
	add_link_constraint bindBones[1] objectA
	add_link_constraint bindBones[2] objectB
	add_link_constraint bindBones[3] objectC


	return bindBones
)


  


function standard_FK_Ctrl myObject riggingGrps = 
(
	newCtrl = make_standard_2d_ctrl "Circle" myObject.name 
	newCtrl.position = myObject.position 
	
	myObject.parent = riggingGrps[2]

	
	add_link_constraint newCtrl myObject

	
	-- parent the new ctrl to the CTRL Rigging GRP 
	newCtrl.parent = riggingGrps[4]
	

)



function get_corrsponding_icons_from_imagePlane objPlan = 
(	
	numbImages = objPlan.material.numsubs
	iconPaths = #()
	
	for i in 1 to numbImages do 
	(
		-- Dig deep for the bitmap of the material, get the planes material which is a mulitsub, then index that for the shader 
		-- then look for the diffusemap file name
		dog = objPlan.material[i].diffusemap.fileName 

		-- Re Configure the file name to add Icon Folder! 
		
		-- Tolkenize file structure
		tolkenizedFilePath = filterString dog "\\" 
		-- get the cont of the tolkenized File Path to use insert a folder
		insertIconIndex = tolkenizedFilePath.count
		-- insert the folder "Icons" into the tolkenizedFilePath
		insertItem "Icons" tolkenizedFilePath insertIconIndex

		-- Now reconfigure the path 
		reconfiguredPath = ""
		for i in tolkenizedFilePath do
		(
			reconfiguredPath += i 
			if i != tolkenizedFilePath[tolkenizedFilePath.count] then
			(
				reconfiguredPath += "\\\\"
			)
		)
		
		append iconPaths reconfiguredPath
	)
	return iconPaths
)



function make_rollout_string_for_materalID numbButtons objPlan = 
(
	iconPaths = get_corrsponding_icons_from_imagePlane objPlan
	
	
	-- imageDir = "C:\\Users\\dkstaff\\Desktop\\LES_SCHWAB_for_Andrez\\02_Elements\\04_Raster\\01_PSDs\\01_Characters\\Man_Image6\\Icons\\_0000_Head_A.png"
	-- numbButtons = numberOfButtons

	_X_counter = 5
	_Y_counter = 40	

	-- crazy ass string formatting to make a rollout with spicific amoutns of buttons
	str = ""

	str += "myAtter3 = attributes Image_Switch\n"
	str += "(\n"	
		--Parameter block to store the tracks of animation 
	str += "parameters testP rollout:testR" 
	str += "(" 
	str += "	animationTrack type:#integer UI:imageSwitchSpinner" 				
	str += ")" 
	str+= "rollout testR \"Material ID Attributes\" \n"
	str+= "(\n"
	str += 	"spinner imageSwitchSpinner \"Image_Switch\" type:#integer range:[1," + numbButtons as string +",1] \n"
	myCounter = 0

	for i in 1 to numbButtons do
	(	
		if i != 1 then 
		(		
			if  mod i 2 == 0 then
			(	
				_X_counter += 80 
				_Y_counter += 0
			)
			
			else
			(
				
				_X_counter -= 80 
				_Y_counter += 80
			)	
		)			
		buttonString = "button btn" + myCounter as string + " \"myButton" + myCounter as string  +"\" pos:[ "+ _X_counter as String +" , "+ _Y_counter as String +"] width:80 height:80  images:#(\""+ iconPaths[myCounter+1] as string + "\" , \""+ iconPaths[myCounter+1] as string +"\", 1, 1, 1, 1, 1) \n"
		str += buttonString

		myCounter += 1
	)
	
	myCounter = 0
	buttonCounter = 1
	for i in 1 to numbButtons do 
	( 
		buttonName = "btn" + myCounter as string
		str += "on "+ buttonName +" pressed do\n"
		str += "(\n"
		str +="for i in selection do\n"
		str += "(\n"
		str += "i.modifiers[#AttributeHolder].Image_Switch[#animationTrack].value = " + buttonCounter as string  +"\n"
		str += ")\n"
		str += ")\n"
		buttonCounter += 1 
		myCounter += 1
	)
	str+= ")\n"
	str+= ")\n"

	return str
)




function add_atters_material_ID_test ctrl str =  
(	-- Add the matererial ID attrabute rollout to the Ctrl object 
	myAtter3 = undefined 
	execute str
	custAttributes.add ctrl.modifiers[#AttributeHolder] myAtter3;	
)

function wireConnect_ctrl_withPlane ctrl objPlan =
(	-- Parent
	--objPlan.parent = ctrl	
	-- Connect Atter
	paramWire.connect2Way ctrl.modifiers[#AttributeHolder].Image_Switch[#animationTrack] objPlan[#Modified_Object][#Material][#Material_ID] "Material_ID" "animationTrack" 	
)	



function connect_ctrl_and_plane ctrl objPlan = 
(	
	---  --> Find out how many images are connected to this specific image plane 
	numbImages = objPlan.material.numsubs
	
	---  --> Add material ID atter range is the max if numbImages 
	
	---  -->  Add materialD button
	str = make_rollout_string_for_materalID numbImages objPlan
	add_atters_material_ID_test ctrl str
	
	---  --> Wire Connect the ctrl material ID to the shader ID on the Plane 
	wireConnect_ctrl_withPlane ctrl objPlan
	
	---  --> Load icons on buttons  
)	


	
function get_image_headder image = 
(
	-- Image should be an full path to the image file :) 
	
	-- Get File name from Path
	filename = filenameFromPath image

	-- Tolkenize by filter "_" into an Array 
	fileNameFilterArray = filterstring filename "_"

	-- The Headder by naming structure should be the first index 
	header = fileNameFilterArray[2]
	
	return header
)



function create_basic_rig_hierarchy characterName = 
(
	Character_GrpName = characterName +"_Rig_Grp" 
	Character_Grp = point centermarker:True  axistripod:false  cross:false box:false name:Character_GrpName
	
	Geo_GrpName = characterName +"_Geo_Grp" 
	Geo_Grp = point centermarker:True  axistripod:false  cross:false box:false name:Geo_GrpName 
	
	Bones_GrpName = characterName +"_Bones_Grp" 
	Bones_Grp = point centermarker:True  axistripod:false  cross:false box:false name:Bones_GrpName
	
	Ctrls_GrpName = characterName +"_Ctrls_Grp" 
	Ctrls_Grp = point centermarker:True  axistripod:false  cross:false box:false name:Ctrls_GrpName
	-- parent all bones to this Bones_Grp
	
	Geo_Grp.parent = Character_Grp
	Bones_Grp.parent = Character_Grp
	Ctrls_Grp.parent = Character_Grp
	
	return #(Character_Grp, Bones_Grp, Ctrls_Grp, Ctrls_Grp)
)

fn check_and_return_rigging_group main groupName =
(	-- This function checks for riging groups that are assoiceated with thename given, 
	-- if non has been created well then you are in luck because it will make one. 
	-- if it is, do not worry it will not! 
	
	riggingGrps = #()
	
	myGroupsString = getuserprop main "Poses" 
	myGroups = filterString myGroupsString "_"
		
	
	if findItem myGroups groupName == 0 then 
	(
		print "Creting Rigging Grp: " +   groupName as string 
		riggingGrps = make_rigging_hierarchy groupName
	)
	
	else 
	(
		
		rigGrp = getnodebyname (groupName +"_Rig_Grp")
		append riggingGrps rigGrp
		geoGrp = getnodebyname (groupName +"_Geo_Grp")
		append riggingGrps geoGrp
		bonesGrp = getnodebyname (groupName +"_Bones_Grp")
		append riggingGrps bonesGrp
		ctrlsGrp = getnodebyname (groupName +"_Ctrls_Grp")
		append riggingGrps ctrlsGrp
		scaleGrp = getnodebyname (groupName + "_Extra_toScale_Grp")
		append riggingGrps scaleGrp
		noScaleGrp = getnodebyname (groupName + "_Extra_noScale_Grp")
		append riggingGrps noScaleGrp
	)
	
	return riggingGrps 

)

fn create_rigging_group main groupName poseNumber = 
(
	print "Creting Rigging Grp: " +   groupName as string 
	riggingGrps = make_rigging_hierarchy groupName
	
	--ss = add_position_scriptController riggingGrps[1] 
	MasterObject = main
	float_script_logic riggingGrps[1] MasterObject poseNumber
	
	return riggingGrps 
)





fn check_if_rigging_group main groupName  = 
(
	riggingGrps = #()
	
	myGroupsString = getuserprop main "Poses" 
	myGroups = filterString myGroupsString "_"
		
	if findItem myGroups groupName == 0 then 
	(
		return false
	)
	else return true 
)	




fn return_riggin_groups main groupName =
(
	riggingGrps = #()
	-- THis funciton can take in not only the string name of a group but also the object
	-- This if, will extract the main suffex name of the group
	if classof groupName == Point then
	(
		groupName = groupName.name
		groupName = substituteString groupName "_Rig_Grp" "" 
	)	
	
	rigGrp = getnodebyname (groupName +"_Rig_Grp")
	append riggingGrps rigGrp
	geoGrp = getnodebyname (groupName +"_Geo_Grp")
	append riggingGrps geoGrp
	bonesGrp = getnodebyname (groupName +"_Bones_Grp")
	append riggingGrps bonesGrp
	ctrlsGrp = getnodebyname (groupName +"_Ctrls_Grp")
	append riggingGrps ctrlsGrp
	scaleGrp = getnodebyname (groupName + "_Extra_toScale_Grp")
	append riggingGrps scaleGrp
	noScaleGrp = getnodebyname (groupName + "_Extra_noScale_Grp")
	append riggingGrps noScaleGrp	
	
	return riggingGrps 
)


function parent_constraint_plane_to_bone myBone myPlane = 
(	-- parent for now instead of constrain 
	myPlane.parent = myBone
)




----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- 
----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- 
function get_rig_groups_from_main main = 
(
	myVar = getuserprop main "Poses"
	myPoses = filterString myVar "_"
	poseNumber = myposes.count
	
	rigGroups = #()
	for i in myPoses do
	(
		-- path name in the future?main.name +"/"
		myGroup = getnodebyname (i +"_Rig_Grp")
		append rigGroups myGroup 
		
	)
	
	return rigGroups
)

function hide_ctrls_in_rigGroup rigGroup = 
(
	
	ctrlsGrp = rigGroup[4]	
	--allChildren #()
	allChildren = addChildren ctrlsGrp #()
	
	for child in allChildren do
	(
		hide child
		freeze child
	)	
)

function show_ctrls_in_rigGroup rigGroup = 
(
	ctrlsGrp = rigGroup[4]	
	--allChildren #()
	allChildren = addChildren ctrlsGrp #()
	
	for child in allChildren do
	(
		unhide child
		unfreeze child
	)	
)



function hide_bones_in_rigGroup rigGroup = 
(
	
	ctrlsGrp = rigGroup[3]	
	--allChildren #()
	allChildren = addChildren ctrlsGrp #()
	
	for child in allChildren do
	(
		hide child
		freeze child
	)	
)


function show_bones_in_rigGroup rigGroup = 
(
	
	ctrlsGrp = rigGroup[3]	
	--allChildren #()
	allChildren = addChildren ctrlsGrp #()
	
	for child in allChildren do
	(
		unhide child
		unfreeze child
	)	
)





function get_rig_non_current_rig_groups main = 
(
	allRigGroups = get_rig_groups_from_main main
	currentPoseNumber = main[#Modified_Object][#Attribute_Holder].poseSwitch[#animationTrack].value
	
	-- if the current poses number is not even a real pose it will be out of index and error. So this s a simple check. 
	-- if it is out of index then all rig groups are not current! 
	if currentPoseNumber <= allRigGroups.count then 
	(	-- Remove the current rig pose from the list 
		allRigGroups = deleteItem allRigGroups currentPoseNumber
	)
	
	-- If there is only one you will get back and empty arry #()
	return allRigGroups 
)	



function get_rig_current_rig_groups main = 
(
	allRigGroups = get_rig_groups_from_main main
	currentPoseNumber = $[#Modified_Object][#Attribute_Holder].poseSwitch[#animationTrack].value
	
	-- Remove the current rig pose from the list 
	current_rig_grp = allRigGroups[currentPoseNumber]
	
	return current_rig_grp 
)	




function hide_all_noncurrent_ctrls main  = 
(	-- get a list of names of the non current riging groups 
	non_current_rig_groups = get_rig_non_current_rig_groups main
	for i in non_current_rig_groups do 
	(	-- get an array of the grpus in a rigging group  
		grps = return_riggin_groups main i
		-- hide the current  
		hide_ctrls_in_rigGroup grps
		hide_bones_in_rigGroup grps
	)
	
	-- get current rigging group
	current_rig_grp = get_rig_current_rig_groups main
	-- get array ig grup in rigging group
	if current_rig_grp != undefined then 
	(	
		grps = return_riggin_groups main current_rig_grp
		show_ctrls_in_rigGroup grps
		show_bones_in_rigGroup grps
	)	
)	


function hide_all_rig_ctrls main = 
(
	rigGrps = get_rig_groups_from_main main
	for i in rigGrps do 
	(	
		grps = return_riggin_groups main i			
		hide_ctrls_in_rigGroup grps 
	)
)







function show_all_rig_ctrls main = 
(
	rigGrps = get_rig_groups_from_main main
	for i in rigGrps do 
	(	
		grps = return_riggin_groups main i			
		show_ctrls_in_rigGroup grps 
		--show_bones_in_rigGroup grps
	)
)









rollout makeIKFK_Rig "DK autoRigger" width:280 height:450
(	
	
	GroupBox PoseGroupBox "MAIN" pos:[5,5] width:275 height:80 
	pickbutton mainCtrlPickBtn "Select Main Ctrl" pos:[30,25] width:200 height:25
	edittext  poseNameText "PoseName" pos:[10,60] width:200 height:20
	button createPoseBtn "Add" pos:[215,60] width:50 height:20 
	
	GroupBox startingPoint "Ctrl Generator" pos:[5,90] width:275 height:275 
	dropdownlist posesDropdown "SET POSE" pos:[10,110] items:#() width:260
	--label limbLabel "LIMB CREATOR" pos:[10, 155]
	
	GroupBox limbCreatorGrpBox "LIMB CREATOR" pos:[10,155] width:250 height:100 
	pickbutton upperLimbPickBtn "upperLimb" pos:[20,175] width:80 height:20 
	pickbutton lowerLimbPickBtn "lowerLimb" pos:[102,175] width:80 height:20
	pickbutton endLimbPickBtn "end" pos:[185,170] width:40 height:30 
	button createIKFKRIGBtn "create IKFK RIG" pos:[20,205] width:200 height:40 
	
	GroupBox planeFK "Standard_FK" pos:[10,260] width:250 height:75
	
	button createFKctrl "Create FK Ctrl" pos:[20,275] width:200 height:40 
	
	
	on mainCtrlPickBtn picked obj do
	(
		if obj != undefined do
		(
			mainCtrlPickBtn.text = obj.name
			-- update set pose
			if getuserprop obj "Poses" == undefined then 		
			(
				setuserprop obj "Poses" ""
				add_empty_modifier_on_object mainCtrlPickBtn.object
				add_atters_Main_switch mainCtrlPickBtn.object
			)
			
			myVar = getuserprop mainCtrlPickBtn.object "Poses"
			myPoses = filterString myVar "_"
			posesDropdown.items = myPoses
		)
	)
	
	on createPoseBtn pressed do 
	(
		groupName = poseNameText.text
		main = mainCtrlPickBtn.object 
		-- check if it already exist 
		check = check_if_rigging_group main groupName 
		
		-- if i does not then
		if check == False then
		(
			myVar = getuserprop mainCtrlPickBtn.object "Poses"
			myPoses = filterString myVar "_"
			poseNumber = (myposes.count + 1)
			rigGroups = create_rigging_group main groupName poseNumber
			rigGroups[1].parent = mainCtrlPickBtn.object
			myVar = getuserprop mainCtrlPickBtn.object "Poses"
			setuserprop mainCtrlPickBtn.object "Poses" (myVar +"_"+ poseNameText.text)
			
		)
	
		else
		(
			rigGroups = return_riggin_groups main groupName
		)
		
		
		-- update set Pose 
		myVar = getuserprop mainCtrlPickBtn.object "Poses"
		myPoses = filterString myVar "_"
		posesDropdown.items = myPoses
	)
	
	
	on upperLimbPickBtn picked obj do
	(
		if obj != undefined do
		(
			upperLimbPickBtn.text = obj.name
		)
	)
	
	
	on lowerLimbPickBtn picked obj do
	(
		if obj != undefined do
		(
			lowerLimbPickBtn.text = obj.name
		)
	)
	
	
	on endLimbPickBtn picked obj do
	(
		if obj != undefined do
		(
			endLimbPickBtn.text = obj.name
		)
	)

	
	on createIKFKRIGBtn pressed do 
	(	
		undo "DK Create IK/FK Rig" on 
		(	-- get rigging grp 
			rigGroups = return_riggin_groups mainCtrlPickBtn.object posesDropdown.selected  
			
			bindBones = make_limb_setup upperLimbPickBtn.object lowerLimbPickBtn.object endLimbPickBtn.object rigGroups 
			
			-- Bind 
	
			
			--upperLimbPickBtn.object.parent = bindBones[1]
			--lowerLimbPickBtn.object.parent = bindBones[2]
			--endLimbPickBtn.object.parent = bindBones[3]
			
			-- clean hircy 
		)	
	)
	
	on createFKctrl pressed do 
	(
		undo "DK Create FK Ctrl" on
		(
			rigGroups = return_riggin_groups mainCtrlPickBtn.object posesDropdown.selected  
			standard_FK_Ctrl $ rigGroups
		)	
	)
	
)



	
--// Drawing User Interface Window
screenHeight = sysInfo.desktopSize[2] --the second value in the point2 is the height
screenMiddle = screenHeight / 2


-- Trying out some new things, this is a try and catch statment 
try (destroydialog makeIKFK_RigGUI) catch()

-- if arrayGUI != undefined do DestroyDialog arrayGUI
	

createDialog makeIKFK_Rig "DK autoRigger" width:280 hight:800 ---380 (screenMiddle-450)
makeIKFK_RigGUI = makeIKFK_Rig


/*
numberOfPoses = 9

for i in 0 to numberOfPoses do
(	
	groupName = "pose"+ i as string
	rigGroups = make_rigging_hierarchy groupName
)
*/







/*

positionA = $pose01_UpperArm_L.position 
positionB = $pose01_LowerArm_L.position 
positionC = $pose01_Hand_L.position 
-- positionD = $tempPlacer_GEO.position 
side = "R"
limbType = "Arm"
 
bindBones = make_limb_setup positionA positionB positionC side limbType




positionA = $UpperArmL_plane_Geo.position 
positionB = $ForArmL_plane_Geo.position 
positionC = $HandL_plane_Geo.position 
-- positionD = $tempPlacer_GEO.position 
side = "L"
limbType = "Arm"

make_limb_setup positionA positionB positionC side limbType




	

-- Corrosponding ctrls to planes! 
-- 
connect_ctrl_and_plane $UpperArm_R_Ctrl $UpperArmR_plane_Geo
connect_ctrl_and_plane $LowerArm_R_Ctrl $ForArmR_plane_Geo
connect_ctrl_and_plane $Wrist_R_Ctrl $HandR_plane_Geo

connect_ctrl_and_plane $Wrist_R_Ik_Ctrl $HandR_plane_Geo

connect_ctrl_and_plane $UpperArm_L_Ctrl $UpperArmL_plane_Geo
connect_ctrl_and_plane $LowerArm_L_Ctrl $ForArmL_plane_Geo
connect_ctrl_and_plane $Wrist_L_Ctrl $HandL_plane_Geo

connect_ctrl_and_plane $Wrist_L_Ik_Ctrl $HandL_plane_Geo




*/


function hide_fk_bones = 
(
	
)




function matchIKtoFK = 
(	
	-- align poleVector
	-- aligh postion
)


function matchFKtoIK = 
(
	-- align sholder
	upperLimb_Ctrl.transform = boneA_IK.transform
	-- align elbow
	lowerLimb_Ctrl.transform = boneB_IK.transform
	-- align wrist
	hand_Ctrl.transform = boneC_IK.transform	
)
	
--matchFKtoIK()



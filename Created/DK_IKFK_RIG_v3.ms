function createEnd selectedBone = 
(	
	parentBone = selectedBone
	parentTrans = parentBone.transform
	parentPos = parentTrans.translation
	 
	newBone = undefined  
	with redraw off 
	(
		newBone = BoneSys.createBone parentPos (parentPos+6) parentBone.dir
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




function create_limb_bone_chain positionA positionB positionC  extraSuffex side limbType boneColor = 
(	-- will create a limb system for you. 
	-- extraSuffex = "FK"
	-- side = "l"
	
	if limbType == "Arm" then
	(
		BoneTypeA = "UpperArm"
		BoneTypeB = "LowerArm"
		BoneTypeC = "Wrist"
	)
	else
	(
		BoneTypeA = "UpperLeg"
		BoneTypeB = "LowerLeg"
		BoneTypeC = "Ankle"
	)
	
	boneA = BoneSys.createBone positionA positionB [0,0,1]   
	boneB = BoneSys.createBone positionB positionC [0,0,1]   
	boneC = createEnd boneB

	boneB.parent = boneA

	boneC.parent = boneB

	boneA.name = BoneTypeA + "_" +  extraSuffex + "_Bone"
	boneB.name = BoneTypeB + "_" +  extraSuffex + "_Bone"
	boneC.name = BoneTypeB + "_" +  extraSuffex + "_Bone"

	boneA.width = 10
	boneA.height = 10
	boneB.width = 10
	boneB.height = 10
	boneC.width = 10
	boneC.height = 10

	boneA.wirecolor = boneColor
	boneB.wirecolor = boneColor
	boneC.wirecolor = boneColor
	
	return #(boneA, boneB, boneC)
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





function ifkf_atter obj= 
--- Create a custom atter --- 
(
	--Create the defintion for the custom attribute 
	myAtter =attributes IK_FK_Blend
	( 
		
	--Parameter block to store the tracks of animation 
	parameters testP rollout:testR 
		( 
			
		--A track of animation 
		--Look under scripted plugins for the types that can be used. 
		animationTrack type:#float UI:mySpinner 
			
		) 

		--The rollout that will show up in the modifier panel. 
		rollout testR "Custom Attributes" 
		(
			
		--The spinner that is connected to the animationTrack 
		spinner mySpinner "FK_IK_Blend" type:#float range:[0,100,0]
		) 	
	) 
	
	eM=emptyModifier() 
	addModifier obj eM 
	--Add the definition to the emptyModifier 
	custAttributes.add eM myAtter;
	
)



function ifkf_atter obj= 
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
	
	
	myAtter2 = attributes Image_Switch
	(	
	--Parameter block to store the tracks of animation 
	parameters testP rollout:testR 
		( 
		
		animationTrack type:#integer UI:imageSwitchSpinner 	
			
		) 

		--The rollout that will show up in the modifier panel. 
		rollout testR "Material ID Attributes" 
		(
			
		--The spinner that is connected to the animationTrack 
		spinner imageSwitchSpinner "Image_Switch" type:#integer range:[1,20,1]
		
		) 	
	)	
 	
	
	
	eM=emptyModifier() 
	addModifier obj eM 
	--Add the definition to the emptyModifier 
	custAttributes.add eM myAtter;
	custAttributes.add eM myAtter2;
)

function make_standard_2d_ctrl type myName = 
(	-- Make the Name of the Controler 
	theName = myName +"_Ctrl"
	-- Creat the Circle 
	if type == "Circle" then
	(	
		theCtrl = circle name:theName steps:3 radius:15 render_displayRenderMesh:true render_viewport_thickness:5
	)
	else if type == "Diamond" then
	(
		theCtrl = circle name:theName steps:0 radius:15 render_displayRenderMesh:true
	)
	else if type == "Rectangle" then
	(		
		theCtrl = Rectangle name:theName length:25 width:25 render_displayRenderMesh:true
	)
	else
	(
		print "The type "+ type as string +"is not a vald argument for funciton make_standard_2d_ctrl"
	)
	-- Add the Image Switch attrabute  
	--add_image_spinner theCtrl

	return theCtrl
)


function set_up_ikBones ikBones =  
(
	--- IK controller set up braaaaaaaa
	ikChain = IKSys.ikChain ikBones[1] ikBones[3] "IKHISolver" 
	ikChain.name ="arm_ik_solver"

	ikCtrl = make_standard_2d_ctrl "Rectangle" "Ik"
	ikCtrl.wirecolor = green 
	--ikCtrl = circle  steps:0 render_displayRenderMesh:true sides:17 radius:50 name:"Ik_Ctrl" wirecolor:green

	ikCtrl.transform = ikBones[3].transform 
	--ikCtrl.position = boneC_IK.position

	ikChain.parent = ikCtrl

	-- create and Ik elbow ctrl poleVector
	--pvCtrl = circle  steps:1 render_displayRenderMesh:true sides:17 radius:50 name:"Ik_PV_Ctrl" wirecolor:green
	pvCtrl = make_standard_2d_ctrl "Diamond" "Ik_PV"
	pvCtrl.wirecolor = green 
	
	pvCtrl.transform = ikBones[2].transform


	-- Add List Rotation + orientation_constraint to Ik wrist joint 
	ikBones[3].rotation.controller = rotation_list()
	orientCtrl = orientation_constraint()
	ikBones[3].rotation.controller.Available.controller = orientCtrl
	orientCtrl.appendTarget ikCtrl 100.0


	-- add pole vececor crl as a rotation target  
	ikChain.transform.controller.VHTarget = pvCtrl
	return #(ikCtrl, pvCtrl)
)



function set_up_fkBones fkBones =  
(
	------- FK Set up 
	upperLimb_Ctrl = make_standard_2d_ctrl "Circle" "upperLimb"
	upperLimb_Ctrl.wirecolor = red
	--upperLimb_Ctrl = circle  steps:3 render_displayRenderMesh:true sides:17 radius:50 name:"upperLimb_Ctrl" wirecolor:red
	upperLimb_Ctrl.rotation = fkBones[1].rotation 
	upperLimb_Ctrl.position = fkBones[1].position

	lowerLimb_Ctrl = make_standard_2d_ctrl "Circle" "lowerLimb"
	lowerLimb_Ctrl.wirecolor = red
	--lowerLimb_Ctrl = circle  steps:3 render_displayRenderMesh:true sides:17 radius:50 name:"lowerLimb_Ctrl" wirecolor:red
	lowerLimb_Ctrl.rotation = fkBones[2].rotation 
	lowerLimb_Ctrl.position = fkBones[2].position

	hand_Ctrl = make_standard_2d_ctrl "Circle" "handLimb"
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
	
	return #(upperLimb_Ctrl, lowerLimb_Ctrl, hand_Ctrl)
	
)


-- $.visibility = True




function make_limb_setup positionA positionB positionC  side limbType = 
(
	-- Create Bones 
	fkBones = create_limb_bone_chain positionA positionB positionC "FK" side limbType Red
	ikBones = create_limb_bone_chain positionA positionB positionC "IK" side limbType Green
	bindBones = create_limb_bone_chain positionA positionB positionC "Bind" side limbType Gray


	-- setup bone blend 
	for i in 1 to 3 do 
	(	
		add_oriention_constraint_to_bind_bones bindBones[i] ikBones[i] fkBones[i]
		paramWire.connect bindBones[i][#transform][#rotation][#Orientation_Constraint][#Orientation_Weight_0]\
		bindBones[i][#transform][#rotation][#Orientation_Constraint][#Orientation_Weight_1] "100-Orientation_Weight_0"

	)



	-- setup IK bones  
	ikControles = set_up_ikBones ikBones

	-- setup FK bones  
	fkControles = set_up_fkBones fkBones

	ikCtrl = ikControles[1]
	ik_pvCtrl = ikControles[2]

	upperLimb_Ctrl = fkControles[1]
	lowerLimb_Ctrl = fkControles[2]
	hand_Ctrl = fkControles[3]


	---------------------------------
	-- set up ikfk blend atter on to the IK ctrl
	ifkf_atter ikCtrl
	for i in 1 to 3 do 
	(	
		paramWire.connect ikCtrl.modifiers[#AttributeHolder].IK_FK_Blend[#animationTrack]\  
		bindBones[i][#transform]	[#rotation][#Orientation_Constraint][#Orientation_Weight_0] "animationTrack"
	)

	--------------------------------

	-- add atter to extra ctrls and 2way connect the atters together
	ifkf_atter ik_pvCtrl
	paramWire.connect2Way ikCtrl.modifiers[#AttributeHolder].IK_FK_Blend[#animationTrack]\ 
	ik_pvCtrl.modifiers[#AttributeHolder].IK_FK_Blend[#animationTrack] "animationTrack" "animationTrack"
	
	ifkf_atter upperLimb_Ctrl
	paramWire.connect2Way ikCtrl.modifiers[#AttributeHolder].IK_FK_Blend[#animationTrack]\ 
	upperLimb_Ctrl.modifiers[#AttributeHolder].IK_FK_Blend[#animationTrack] "animationTrack" "animationTrack"


	ifkf_atter lowerLimb_Ctrl
	paramWire.connect2Way ikCtrl.modifiers[#AttributeHolder].IK_FK_Blend[#animationTrack]\ 
	lowerLimb_Ctrl.modifiers[#AttributeHolder].IK_FK_Blend[#animationTrack] "animationTrack" "animationTrack"


	ifkf_atter hand_Ctrl
	paramWire.connect2Way ikCtrl.modifiers[#AttributeHolder].IK_FK_Blend[#animationTrack]\ 
	hand_Ctrl.modifiers[#AttributeHolder].IK_FK_Blend[#animationTrack] "animationTrack" "animationTrack"
)






function connect_plane_with_ctrl objPlan ctrl =
(	-- Parent
	--objPlan.parent = ctrl	
	-- Connect Atter
	paramWire.connect2Way ctrl.modifiers[#AttributeHolder].Image_Switch[#animationTrack] objPlan[#Modified_Object][#Material][#Material_ID] "Material_ID" "animationTrack" 	
)	







positionA = $UpperArmR_plane_Geo.position 
positionB = $ForArmR_plane_Geo.position 
positionC = $HandR_plane_Geo.position 
-- positionD = $tempPlacer_GEO.position 
side = "R"
limbType = "Arm"
 
make_limb_setup positionA positionB positionC side limbType

-- Connect material ID to Ctrls
connect_plane_with_ctrl $UpperArmR_plane_Geo $upperLimb_Ctrl
connect_plane_with_ctrl $ForArmR_plane_Geo $lowerLimb_Ctrl
connect_plane_with_ctrl $ForArmR_plane_Geo $Ik_PV_Ctrl
connect_plane_with_ctrl $HandR_plane_Geo $Ik_Ctrl
connect_plane_with_ctrl $HandR_plane_Geo $handLimb_Ctrl






positionA = $UpperArmL_plane_Geo.position 
positionB = $ForArmL_plane_Geo.position 
positionC = $HandL_plane_Geo.position 
-- positionD = $tempPlacer_GEO.position 
side = "L"
limbType = "Arm"

make_limb_setup positionA positionB positionC side limbType



--- Create Ctrls
--- Connect control to image plane 
---  --> Add material ID atter 
---  --> Find out how many images are connected to this specific ctrl
---  -->  Connect the ctrl material ID to the shader ID 
---  -->  Add materialD buttons
---  --> Load icons on buttons  


function connect_ctrl_and_plane ctrl myplane = 
(	
	---  --> Find out how many images are connected to this specific image plane 
	numbImages = myplane.material.numsubs
	
	---  --> Add material ID atter range is the max if numbImages 
	
	---  -->  Add materialD button
	str = make_rollout_string_for_materalID numbImages 
	add_atters_material_ID_test ctrl str
	
	---  -->  Connect the ctrl material ID to the shader ID 
	connect_plane_with_ctrl myplane ctrl
	
	
	
	---  --> Load icons on buttons  
)	

add_empty_modifier_on_object $Box011

connect_ctrl_and_plane $Box011 $Head_plane_Geo 
	
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
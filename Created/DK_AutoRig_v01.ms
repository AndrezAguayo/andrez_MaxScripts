
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
	
	hide ikChain
	
	--{POS_X,POS_Y,POS_Z,ROT_X,ROT_Y,ROT_Z,SCALE_X,SCALE_Y,SCALE_Z}
	--{    1     ,     2    ,    3      ,    4    ,     5    ,     6    ,      7       ,      8       ,     9        }
	setTransformLockFlags ikCtrl #{2,4,6,7,8,9}
	
	
	add_defult_user_properties ikChain "hidden" "frozen"
	
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
	--allign ctrl to bone 
	upperLimb_Ctrl.rotation = fkBones[1].rotation 
	upperLimb_Ctrl.position = fkBones[1].position

	--lowerLimb_CtrlName = limbNameB + "_" + side 
	lowerLimb_Ctrl = make_standard_2d_ctrl "Circle" BoneNameB
	lowerLimb_Ctrl.wirecolor = red
	--allign ctrl to bone 
	lowerLimb_Ctrl.rotation = fkBones[2].rotation 
	lowerLimb_Ctrl.position = fkBones[2].position

	--handLimb_CtrlName = limbNameC + "_" + side 
	hand_Ctrl = make_standard_2d_ctrl "Circle" BoneNameC
	hand_Ctrl.wirecolor = red
	--allign ctrl to bone 
	hand_Ctrl.rotation = fkBones[3].rotation 
	hand_Ctrl.position = fkBones[3].position


	-- Add list rotation and position ctrl to fk joints 
	fkBones[1].rotation.controller = rotation_list()
	orientCtrl = orientation_constraint()
	fkBones[1].rotation.controller.Available.controller = orientCtrl
	orientCtrl.appendTarget upperLimb_Ctrl 100.0

	--fkBones[1].position.controller = position_list()
	--positionCtrl = position_constraint()
	--fkBones[1].position.controller.Available.controller = positionCtrl
	--positionCtrl.appendTarget upperLimb_Ctrl 100.0


	fkBones[2].rotation.controller = rotation_list()
	orientCtrl = orientation_constraint()
	fkBones[2].rotation.controller.Available.controller = orientCtrl
	orientCtrl.appendTarget lowerLimb_Ctrl 100.0

	---fkBones[2].position.controller = position_list()
	---positionCtrl = position_constraint()
	--fkBones[2].position.controller.Available.controller = positionCtrl
	--positionCtrl.appendTarget lowerLimb_Ctrl 100.0


	fkBones[3].rotation.controller = rotation_list()
	orientCtrl = orientation_constraint()
	fkBones[3].rotation.controller.Available.controller = orientCtrl
	orientCtrl.appendTarget hand_Ctrl 100.0

	--fkBones[3].position.controller = position_list()
	--positionCtrl = position_constraint()
	--fkBones[3].position.controller.Available.controller = positionCtrl
	--positionCtrl.appendTarget hand_Ctrl 100.0

	hand_Ctrl.parent = lowerLimb_Ctrl
	lowerLimb_Ctrl.parent = upperLimb_Ctrl
	
	-- parent in to proper group 
	upperLimb_Ctrl.parent = ctrlGrp
	--lowerLimb_Ctrl.parnet = ctrlGrp
	--hand_Ctrl.parent = ctrlGrp
	
	
	
	--{POS_X,POS_Y,POS_Z,ROT_X,ROT_Y,ROT_Z,SCALE_X,SCALE_Y,SCALE_Z}
	--{    1     ,     2    ,    3      ,    4    ,     5    ,     6    ,      7       ,      8       ,     9        }
	setTransformLockFlags upperLimb_Ctrl #{1,2,3,4,6,7,8,9}
	setTransformLockFlags lowerLimb_Ctrl #{1,2,3,4,6,7,8,9}
	setTransformLockFlags hand_Ctrl #{1,2,3,4,6}
	
	
	return #(upperLimb_Ctrl, lowerLimb_Ctrl, hand_Ctrl)
	
)



function make_limb_setup objectA objectB objectC rigGroups = 
(
	limbObjects = #(objectA, objectB, objectC)
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
	
	fkBones = create_limb_bone_chain objectA.position objectB.position objectC.position "FK" prefix_A prefix_B prefix_C bonesGrp Red "Hide"
	ikBones = create_limb_bone_chain objectA.position objectB.position objectC.position "IK" prefix_A prefix_B prefix_C bonesGrp Green "Hide"
	bindBones = create_limb_bone_chain objectA.position objectB.position objectC.position "Bind" prefix_A prefix_B prefix_C bonesGrp Gray "Hide"

	-- Setup bone blend 
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
	

	-- suto code for scaling the ctrls when switched from ik to fk 
	-- for all fk ctrls do ---> wire peram  ik_fk_blend = scale/100 
	-- for all ik ctrls do ---> wire peram  ik_fk_blend = 1 - (scale/100) 
	paramWire.connect ikCtrl.modifiers[#AttributeHolder].IK_FK_Blend[#animationTrack] \ 
	ikCtrl.modifiers[#xform].gizmo[#scale] "[animationTrack/100,animationTrack/100,animationTrack/100]"
	
	
	for i in 1 to fkControles.count do
	(	
		paramWire.connect ikCtrl.modifiers[#AttributeHolder].IK_FK_Blend[#animationTrack] \
		fkControles[i].modifiers[#xform].gizmo[#scale] "[1-animationTrack/100,1-animationTrack/100,1-animationTrack/100]"
	)

	bone_master = point centermarker:false  axistripod:false  cross:false box:false name:(prefix_A +"_BoneMaster") size:1 
	ctrl_master = point centermarker:false  axistripod:false  cross:false box:false name:(prefix_A +"_CtrlMaster") size:2  
	limb_master = point centermarker:false  axistripod:false  cross:false box:true name:(prefix_A +"_Master") size:5  

	limb_master.position = bindBones[1].position
	ctrl_master.position = bindBones[1].position
	bone_master.position = bindBones[1].position
	
	add_defult_user_properties bone_master "hidden" "not_frozen"
	add_defult_user_properties ctrl_master "hidden" "not_frozen"
	add_defult_user_properties limb_master "hidden" "not_frozen"
	
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
	
	
	
	
	the_counter = 1
	for i in limbObjects do 
	(	-- parent geo to geo grp 
		i.parent = geoGrp
		if the_counter < 3 then
		(	
			add_link_constraint bindBones[the_counter] i
			-- Set user property that states that geometry objects should be frozen but not hidden
			add_defult_user_properties i "not_hidden" "frozen"
			--Freeze geometry so that is is not selectable. 
			freeze i
			i.showFrozenInGray = off
			the_counter+=1
		)
		--if the_counter == 3 then
		--(
			--add_image_slider_attr i
			--print "poop"
		--)		
		
	)
	
	add_image_slider_attr hand_Ctrl
	
	-- Set_up_image_swapping_atter newCtrl myObject riggingGrps newCtrl 
	set_up_image_swapping_atter ikctrl limbObjects[3] riggingGrps bindBones[3] 
	-- Connect_image_slider_to_object newCtrl myObject
	connect_image_slider_to_object ikctrl limbObjects[3]
	
	return bindBones
)



function standard_FK_Ctrl myObject riggingGrps = 
(
	newCtrl = make_standard_2d_ctrl "Circle" myObject.name 
	newCtrl.position = myObject.position 

	--ANDREZZZZ
	
	set_up_image_swapping_atter newCtrl myObject riggingGrps newCtrl 
	/*
	imageSwitchGrp = PointHelperObj box:off cross:off axistripod:off centermarker:off size:20 name:(myObject.name +"_imageSwitching_Grp")
	--rigGrp = PointHelperObj box:off cross:off axistripod:off centermarker:off size:20 name:(poseName +"_Rig_Grp")
	
	add_defult_user_properties imageSwitchGrp "not_hidden" "not_frozen"
	
	myObject.parent = imageSwitchGrp
	imageSwitchGrp.parent = riggingGrps[2]

	-- constrainst the new image switch grp to the ctrl 
	add_link_constraint newCtrl imageSwitchGrp
	
	-- tag ctrl with the image image switch geo grp data 
	setuserprop newCtrl "ImageSwitch_Geo_Grp" imageSwitchGrp.name
		
	-- add image swap atter on the ctrl 
	add_empty_modifier_on_object newCtrl
	add_atters_image_slider newCtrl
	
	-- connect  initial image to the slider 
	connect_image_slider_to_object newCtrl myObject
	*/
	
	connect_image_slider_to_object newCtrl myObject
	
	-- parent the new ctrl to the CTRL Rigging GRP 
	newCtrl.parent = riggingGrps[4]
	--add_link_constraint newCtrl myObject
	
	add_defult_user_properties myObject "not_hidden" "frozen"
	freeze myObject
	myObject.showFrozenInGray = off
)
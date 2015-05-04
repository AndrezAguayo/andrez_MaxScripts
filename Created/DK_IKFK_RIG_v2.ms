currentSelection = getCurrentSelection()


positionA = $.position 
positionB = $.position 
positionc = $.position 
positionD = $.position 
bone 


positionA

b0 = bone pos:positionA
in b0 b1 = bone pos:positionB
in b1 b2 = bone pos:positionC
	



boneA_FK = BoneSys.createBone positionA positionB [0,0,1]   
boneB_FK = BoneSys.createBone positionB positionC [0,0,1]   
boneC_FK = BoneSys.createBone positionC positionD [0,0,1] 

boneB_FK.parent = boneA_FK

boneC_FK.parent = boneB_FK

boneA_FK.name = "UpperArm_FK_Bone"
boneB_FK.name = "LowerArm_FK_Bone"
boneC_FK.name = "WristArm_FK_Bone"

boneA_FK.width = 10
boneA_FK.height = 10
boneB_FK.width = 10
boneB_FK.height = 10
boneC_FK.width = 10
boneC_FK.height = 10

boneA_FK.wirecolor = red
boneB_FK.wirecolor = red
boneC_FK.wirecolor = red





boneA_IK = BoneSys.createBone positionA positionB [0,0,1]   
boneB_IK = BoneSys.createBone positionB positionC [0,0,1]   
boneC_IK = BoneSys.createBone positionC positionD [0,0,1] 

boneB_IK.parent = boneA_IK

boneC_IK.parent = boneB_IK

boneA_IK.name = "UpperArm_IK_Bone"
boneB_IK.name = "LowerArm_IK_Bone"
boneC_IK.name = "WristArm_IK_Bone"

boneA_IK.width = 8
boneA_IK.height = 8
boneB_IK.width = 8
boneB_IK.height = 8
boneC_IK.width = 8
boneC_IK.height = 8 

boneA_IK.wirecolor = green
boneB_IK.wirecolor = green
boneC_IK.wirecolor = green



boneA_Bind = BoneSys.createBone positionA positionB [0,0,1]   
boneB_Bind = BoneSys.createBone positionB positionC [0,0,1]   
boneC_Bind = BoneSys.createBone positionC positionD [0,0,1] 

boneB_Bind.parent = boneA_Bind

boneC_Bind.parent = boneB_Bind

boneA_Bind.name = "UpperArm_Bind_Bone"
boneB_Bind.name = "LowerArm_Bind_Bone"
boneC_Bind.name = "WristArm_Bind_Bone"

boneA_Bind.width = 5
boneA_Bind.height = 5
boneB_Bind.width = 5
boneB_Bind.height = 5
boneC_Bind.width = 5
boneC_Bind.height = 5

boneA_Bind.wirecolor = gray
boneB_Bind.wirecolor = gray
boneC_Bind.wirecolor = gray








-- set some shit up! 
boneA_Bind.rotation.controller = rotation_list()
orientCtrl = orientation_constraint()
boneA_Bind.rotation.controller.Available.controller = orientCtrl


orientCtrl.appendTarget boneA_IK 50.0
orientCtrl.appendTarget boneA_FK 50.0




-- set some shit up! 
boneB_Bind.rotation.controller = rotation_list()
orientCtrl = orientation_constraint()
boneB_Bind.rotation.controller.Available.controller = orientCtrl


orientCtrl.appendTarget boneB_IK 50.0
orientCtrl.appendTarget boneB_FK 50.0



-- set some shit up! 
boneC_Bind.rotation.controller = rotation_list()
orientCtrl = orientation_constraint()
boneC_Bind.rotation.controller.Available.controller = orientCtrl


orientCtrl.appendTarget boneC_IK 50.0
orientCtrl.appendTarget boneC_FK 50.0

paramWire.connect boneA_Bind[#transform][#rotation][#Orientation_Constraint][#Orientation_Weight_0] boneA_Bind[#transform][#rotation][#Orientation_Constraint][#Orientation_Weight_1] "100-Orientation_Weight_0"
paramWire.connect boneB_Bind[#transform][#rotation][#Orientation_Constraint][#Orientation_Weight_0] boneB_Bind[#transform][#rotation][#Orientation_Constraint][#Orientation_Weight_1] "100-Orientation_Weight_0"
paramWire.connect boneC_Bind[#transform][#rotation][#Orientation_Constraint][#Orientation_Weight_0] boneC_Bind[#transform][#rotation][#Orientation_Constraint][#Orientation_Weight_1] "100-Orientation_Weight_0"




function ifkf_atter obj= 
--- Create a custom atter --- 
(
	--Create the defintion for the custom attribute 
	myAtter =attributes IK_FK_Switch 
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
		spinner mySpinner "IK_FK_Switch" type:#float range:[0,100,0]
		) 	
	) 
	
	eM=emptyModifier() 
	addModifier obj eM 
	--Add the definition to the emptyModifier 
	custAttributes.add eM myAtter;
	
)







paramWire.connect obj.modifiers[#AttributeHolder].IK_FK_Switch[#animationTrack]  boneA_Bind[#transform][#rotation][#Orientation_Constraint][#Orientation_Weight_0]  "animationTrack"
paramWire.connect obj.modifiers[#AttributeHolder].IK_FK_Switch[#animationTrack]  boneB_Bind[#transform][#rotation][#Orientation_Constraint][#Orientation_Weight_0]  "animationTrack"
paramWire.connect obj.modifiers[#AttributeHolder].IK_FK_Switch[#animationTrack]  boneC_Bind[#transform][#rotation][#Orientation_Constraint][#Orientation_Weight_0]  "animationTrack"




obj= $
ifkf_atter obj









From the Macro_BoneAdjustmentsTools.mcr:on CreateEnd_btn pressed do
(
undo "Create End" on
	(
		if (selection.count == 1) do
		(
		with Animate Off --with Animate Off bracket open
			( 
			local parentBone = selection[1]
			local parentTrans = parentBone.transform
			local parentPos = parentTrans.translation
			local newbone

			with redraw off (
				newBone=BoneSys.createBone parentPos (parentPos+6) parentBone.dir
				newBone.transform = parentTrans
				in coordSys Local move newBone [parentBone.length,0,0]

				newBone.parent	= parentBone
				putChildIntoAssembly newBone

				newBone.width	= parentBone.width
				newBone.height	= parentBone.height
				newBone.taper	= 90
				newBone.length	= (parentBone.width+parentBone.height)/2
				newBone.wirecolor = parentBone.wirecolor

				select newBone
			)

			redrawViews()

			) -- with Animate Off bracket close
		)
	)
)


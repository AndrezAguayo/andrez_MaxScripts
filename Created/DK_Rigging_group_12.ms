---------------------------------------------------------------------------------------------------------------------------------------
-- Creating the Rigging hiarchys funciton 
--------------------------------------------------------------------------------------------------------------------------------------- 
function make_rigging_hierarchy poseName = 
(	
	if classof poseName == String then 
	(	
		rigGrp = PointHelperObj box:off cross:off axistripod:off centermarker:off size:20 name:(poseName +"_Rig_Grp")
		geoGrp = PointHelperObj box:off cross:off axistripod:off centermarker:off size:20 name:(poseName +"_Geo_Grp")
		bonesGrp = PointHelperObj box:off cross:off axistripod:off centermarker:off size:20 name:(poseName +"_Bones_Grp")
		ctrlsGrp = PointHelperObj box:off cross:off axistripod:off centermarker:off size:20 name:(poseName +"_Ctrls_Grp")	
		scaleGrp = PointHelperObj box:off cross:off axistripod:off centermarker:off size:20 name:(poseName + "_Extra_toScale_Grp")
		noScaleGrp = PointHelperObj box:off cross:off axistripod:off centermarker:off size:20 name:(poseName + "_Extra_noScale_Grp")
		
		add_defult_user_properties rigGrp "not_hidden" "not_frozen"
		add_defult_user_properties geoGrp "not_hidden" "not_frozen"
		add_defult_user_properties bonesGrp "not_hidden" "not_frozen"
		add_defult_user_properties ctrlsGrp "not_hidden" "not_frozen"
		add_defult_user_properties scaleGrp "not_hidden" "not_frozen"
		add_defult_user_properties noScaleGrp "not_hidden" "not_frozen"
		
		geoGrp.parent = rigGrp	
		bonesGrp.parent = rigGrp
		ctrlsGrp.parent = rigGrp
		scaleGrp.parent = rigGrp
		noScaleGrp.parent = rigGrp
	)
	else 
	(
		print "ERROR on function: create_basic_rig_hierarchy characterName arg. is not a String"
		return undefined
	)
	
	return #(rigGrp, geoGrp, bonesGrp, ctrlsGrp, scaleGrp, noScaleGrp)
)


function add_pose_group main poseName poseNumber = 
(
	-- makes  a hierachy for grups with the given group name 
	print "Creting Rigging Grp: " + (poseName as string) 
	riggingGrps = make_rigging_hierarchy poseName
	
	-- add a float script to control the visiblity of the rigging group 
	float_script_logic riggingGrps[1] main poseNumber
	
	-- parent the rig group to main. 
	riggingGrps[1].parent = main
	/*
	-- This code adds one to the rollout spinner for the pose switcher, this way you only can only slide it in the range of actuall poses, 
	-- and will continue to add to this dynamicly so you can continuely add poses 
	--print "here is main: "
	--print main 
	--currentPosesVal = main.modifiers[#AttributeHolder].poseSwitcher
	--print "currentPosesVal: "
	--print currentPosesVal
	--currentRange = main.modifiers[#AttributeHolder].params.poseSwitchsSpinner.range
	--print "current posewitcher range: " 
	--print currentRange
	
	poseSwitcherMax = (main.modifiers[#AttributeHolder].params.poseSwitchsSpinner.range)[2]
	--print " here is poseSwitcherMax:" 
	--print poseSwitcherMax
	
	-- newrange = [1,(poseSwitcherMax+1),currentPosesVal]
	-- print " here is new Range:" 
	-- print newrange
		
	poseSwitcherMax = (main.modifiers[#AttributeHolder].params.poseSwitchsSpinner.range)[2]
	print "here is pose max" 
	print poseSwitcherMax
	main.modifiers[#AttributeHolder].params.poseSwitchsSpinner.range[2] = (poseSwitcherMax +1)
	--if (newrange != main.modifiers[#AttributeHolder].params.poseSwitchsSpinner.range) then
	--( main.modifiers[#AttributeHolder].params.poseSwitchsSpinner.range = newrange )
	
	
	print " here is new poseSwitche range:" 
	poseSwitcherMax = main.modifiers[#AttributeHolder].params.poseSwitchsSpinner.range
	print poseSwitcherMax
	*/
	
	add_pose_button main poseName
	
	return riggingGrps 
)



--if ([(myRange[1]), (myRange[2]), (myRange[3])] != $.modifiers[#AttributeHolder].params.poseSwitchsSpinner.range) then
--( $.modifiers[#AttributeHolder].params.poseSwitchsSpinner.range = [(myRange[1]), (myRange[2]), (myRange[3])] )

---------------------------------------------------------------------------------------------------------------------------------------
-- Checking the Rigging groups  funciton 
---------------------------------------------------------------------------------------------------------------------------------------

-- enableSceneRedraw();
-- $.modifiers[#AttributeHolder].poseSwitcher = 2
-- curtime = currenttime 
-- slidertime = curtime+1f
-- slidertime = curtime

function check_if_is_pose main poseName  = 
(
	riggingGrps = #()
	-- get the user property Poses
	myGroupsString = getuserprop main "Poses" 
	-- filter the string to recive group names 
	myGroups = filterString myGroupsString "_"
	
	-- return true if group name is found inside of the rigging group 	
	if findItem myGroups poseName == 0 then 
	(
		return false
	)
	else return true 
)	

fn check_if_is_parent_return_child parent potentialChildren = 
(
	for i in potentialChildren do 
	(
		if i.parent == parent then
		(
			return i 
		)
	)		
	print "Returning undfined for funciton check_if_is_parent_return_child this means\ 
	that there is no rig group corrosponding to the main"
	return undefined
		
)

fn return_rigging_groups main groupName =
(
	riggingGrps = #()
	-- This funciton can take in not only the string name of a group but also the object
	-- This if, will extract the main suffex name of the group
	if classof groupName == Point then
	(
		groupName = groupName.name
		groupName = substituteString groupName "_Rig_Grp" "" 
	)	
	
	rigGrps = getnodebyname (groupName +"_Rig_Grp") all:true
	rigGrp = check_if_is_parent_return_child main rigGrps
	append riggingGrps rigGrp
	
	geoGrp = getnodebyname (groupName +"_Geo_Grp") all:true
	geoGrp = check_if_is_parent_return_child rigGrp geoGrp
	append riggingGrps geoGrp
		
	bonesGrp = getnodebyname (groupName +"_Bones_Grp") all:true
	bonesGrp = check_if_is_parent_return_child rigGrp bonesGrp
	append riggingGrps bonesGrp
	
	ctrlsGrp = getnodebyname (groupName +"_Ctrls_Grp") all:true
	ctrlsGrp = check_if_is_parent_return_child rigGrp ctrlsGrp
	append riggingGrps ctrlsGrp
	
	scaleGrp = getnodebyname (groupName + "_Extra_toScale_Grp") all:true
	scaleGrp = check_if_is_parent_return_child rigGrp scaleGrp
	append riggingGrps scaleGrp
	
	noScaleGrp = getnodebyname (groupName + "_Extra_noScale_Grp") all:true
	noScaleGrp = check_if_is_parent_return_child rigGrp noScaleGrp
	append riggingGrps noScaleGrp	
	
	return riggingGrps 
)


function get_pose_groups_from_main main = 
(
	myVar = getuserprop main "Poses"
	myPoses = filterString myVar "_"
	--poseNumber = myposes.count
	
	poseGroups = #()
	for i in myPoses do
	(
		-- path name in the future?main.name +"/"
		poseGroup = getnodebyname (i +"_Rig_Grp") all:true
		poseGroup = check_if_is_parent_return_child main poseGroup
		append poseGroups poseGroup 
		
	)
	
	return poseGroups
)


function get_non_current_pose_groups main = 
(
	allRigGroups = get_pose_groups_from_main main
	currentPoseNumber = main[#Modified_Object][#Attribute_Holder].poseSwitch[#poseSwitcher].value
	
	-- if the current poses number is not even a real pose it will be out of index and error. So this s a simple check. 
	-- if it is out of index then all rig groups are not current! 
	if currentPoseNumber <= allRigGroups.count then 
	(	-- Remove the current rig pose from the list 
		poseGroups = deleteItem allRigGroups currentPoseNumber
	)
	
	-- If there is only one you will get back and empty arry #()
	return poseGroups 
)	


function get_rig_current_pose_group main = 
(
	allRigGroups = get_pose_groups_from_main main
	currentPoseNumber = $[#Modified_Object][#Attribute_Holder].poseSwitch[#poseSwitcher].value
	
	-- Remove the current rig pose from the list 
	current_pose_grp = allRigGroups[currentPoseNumber]
	
	return current_pose_grp 
)	


---------------------------------------------------------------------------------------------------------------------------------------
-- Using the Rigging groups  funciton 
--------------------------------------------------------------------------------------------------------------------------------------
function manipulate_group_in_pose rigGroups grpType Hide_or_Show = 
(	if(grpType == "Pose") then (manipulateGrp = rigGroups[1]) 	
	else if(grpType == "Geo") then (manipulateGrp = rigGroups[2]) 	
	else if(grpType == "Bones") then (manipulateGrp = rigGroups[3]) 	
	else if(grpType == "Ctrls") then (manipulateGrp = rigGroups[4]) 	 
	else if(grpType == "Scale") then (manipulateGrp = rigGroups[5]) 	
	else if(grpType == "noScale") then (manipulateGrp = rigGroups[6]) 	
	
	-- get all children in hiearcy 
	allChildren = addChildren manipulateGrp #()
	if (Hide_or_Show == "Show") then
	(	for child in allChildren do
		(	defultHidden = getuserprop child "defultHidden"
			defultFrozen = getuserprop child "defultFrozen"
			if defultHidden == false then 
			(	
				unhide child
			)
			if defultFrozen == false then 
			(
				unfreeze child
			)	
		)
	)
	else if (Hide_or_Show == "Hide") then 
	(	for child in allChildren do
		(	--defultHidden = getuserprop child "defultHidden"
			--defultHidden = getuserprop child "defultFrozen"
			--if defultHidden == false
			--(
			hide child
			--)
				--if defultFrozen == false
			--(	
			freeze child
			--)	
		)
	)
)


function hide_all_noncurrent_ctrls main  = 
(	-- get a list of names of the non current riging groups 
	non_current_rig_groups = get_non_current_pose_groups main
	for i in non_current_rig_groups do 
	(	-- get an array of the grpus in a rigging group  
		grps = return_rigging_groups main i
		-- hide the current  
		manipulate_group_in_pose grps "Ctrls" "Hide" 
		--manipulate_group_in_pose grps "Bones" "Hide" 
		manipulate_group_in_pose grps "Geo" "Hide" 
	)
	
	-- get current rigging group
	current_rig_grp = get_rig_current_pose_group main
	-- get array ig grup in rigging group
	if current_rig_grp != undefined then 
	(	
		grps = return_rigging_groups main current_rig_grp
		manipulate_group_in_pose grps "Ctrls" "Show" 
		--manipulate_group_in_pose grps "Bones" "Show" 
		manipulate_group_in_pose grps "Geo" "Show" 
	)	
)	


function hide_all_rig_ctrls main = 
(
	rigGrps = get_pose_groups_from_main main
	for i in rigGrps do 
	(	
		grps = return_rigging_groups main i			
		manipulate_group_in_pose grps "Ctrls" "Hide" 
	)
)

function unhide_all_poses main = 
(
	rigGrps = get_pose_groups_from_main main
	for i in rigGrps do 
	(	
		grps = return_rigging_groups main i			
		manipulate_group_in_pose grps "Ctrls" "Show" 
		manipulate_group_in_pose grps "Geo" "Show" 
	)
)

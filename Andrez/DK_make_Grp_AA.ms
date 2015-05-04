function make_a_group_from_selection = 
(	
	mySelection = getCurrentSelection()
	pGrpParent = get_first_matching_parent mySelection
	myPoint = PointHelperObj box:off cross:off axistripod:off centermarker:off size:20
	--mySelection = getCurrentSelection()
	
	print "This is the pGrpParent"
	print pGrpParent
	myPoint.parent = pGrpParent
	myPoint.name = mySelection[1].name + "_pGrp"
	
	for i in selection do
	(
		i.parent = myPoint
	)	
)


function addParnet obj hierarchy = 
(	--append hierarchy obj 
	if obj.parent != undefined then 
	(	obj = obj.parent
		append hierarchy obj 
		addParnet obj hierarchy
	)
	return hierarchy
)	

function get_matching_parent_list parentlistA parentlistB =
(
	matchingParentList = #()
	for i in parentlistB do
	(	for j in parentlistA do
		(	if (i == j) then 
			(	--print i
				append matchingParentList i
			)		
		)	
	)	
	
	return matchingParentList 
)


function get_first_matching_parent theSelection = 
(
	for i in 1 to theSelection.count do
	(
		if i == 1 then 
		(		
			parentlistA = addParnet theSelection[i] #()
			current_matching = parentlistA
		)
		else 
		(
			parentlistB = addParnet theSelection[i] #()
			current_matching = get_matching_parent_list parentlistA parentlistB
			parentlistA = current_matching
		)	
	) 

	return  current_matching[1]
)



make_a_group_from_selection()

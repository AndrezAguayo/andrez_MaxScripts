


function make_a_group_from_selection = 
(	
	myPoint = PointHelperObj box:off cross:off axistripod:off centermarker:on size:20
	mySelection = getCurrentSelection()

	myPoint.name = mySelection[1].name + "_Grp"
	
	for i in selection do
	(
		i.parent = myPoint
	)	

)


make_a_group_from_selection()












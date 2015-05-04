-- Parent 

$.parent
$
$.child 



------- 

MainBone = $

mainCtrl = make_standard_ctrl "Circle"  MainBone.Name
setuserprop MainBone "FK_Ctrl" mainCtrl.name

mainCtrl.rotation = MainBone.rotation
mainCtrl.position = MainBone.position



MainBone = $

-- get fk ctrl 
FK_Ctrl = execute( "$" + getuserprop MainBone "FK_Ctrl")
thePositionConstraint = add_position_constraintController MainBone
thePositionConstraint.appendTarget FK_Ctrl 100
thePositionConstraint.relative = true

--- need to get the childd joints Ctrl 
FK_Ctrl = execute( "$" + getuserprop MainBone.children[1] "FK_Ctrl")
theLookAtConstraint = add_look_at_constraint_controller MainBone
theLookAtConstraint.appendTarget FK_Ctrl 100




myHierarchy = addChildren $ #()

for aBone in myHierarchy do 
(	MainBone = aBone
	mainCtrl = make_standard_ctrl "Circle"  MainBone.Name
	setuserprop MainBone "FK_Ctrl" mainCtrl.name

	mainCtrl.rotation = MainBone.rotation
	mainCtrl.position = MainBone.position
)

for aBone in myHierarchy do 
(	MainBone = aBone
	-- get fk ctrl 
	FK_Ctrl = execute( "$" + getuserprop MainBone "FK_Ctrl")
	thePositionConstraint = add_position_constraintController MainBone
	thePositionConstraint.appendTarget FK_Ctrl 100
	thePositionConstraint.relative = true
	
	if has_children MainBone then 
	(
		--- need to get the childd joints Ctrl 
		FK_Ctrl_Child = execute( "$" + getuserprop MainBone.children[1] "FK_Ctrl")
		theLookAtConstraint = add_look_at_constraint_controller MainBone
		theLookAtConstraint.appendTarget FK_Ctrl_Child 100
		FK_Ctrl_Child.parent = FK_Ctrl
	)	 
	
	
	
)






function has_children obj = 
(
	if MainBone.children.count > 0.1 then
	(
		return True 
	)
	else 
	(
		return False 
	)
)	


function make_standard_ctrl type myName = 
(	-- Make the Name of the Controler 
	theName = myName +"_Ctrl"
	-- Depending on the type you want make that shape.
	if type == "Circle" then
	(	
		theCtrl = circle name:theName steps:5 radius:5 render_displayRenderMesh:true render_viewport_thickness:.1 render_thickness:.1	
	)
	else if type == "Diamond" then
	(
		theCtrl = circle name:theName steps:0 radius:1.5 render_displayRenderMesh:true render_viewport_thickness:.1 render_thickness:.1
	)
	else if type == "Rectangle" then
	(		
		theCtrl = Rectangle name:theName length:2 width:2 render_displayRenderMesh:true render_viewport_thickness:.1 render_thickness:.1
	)
	else
	(   -- Print the name of the shape given tjhat is not  a vald argument
		print "The type "+ type as string +"is not a vald argument for funciton make_standard_2d_ctrl"
		return empty 
	)
	-- Do some things I want all ctrls to do :) 
	ep = edit_poly() 
	xfm = xform()
	addModifier theCtrl ep
	addModifier theCtrl xfm
	theCtrl.renderable = False

	return theCtrl
)



function add_position_constraint_controller obj  =
(
	-- create a Position List controller for the position controller
	obj.pos.controller = position_list()

	-- create a Position Script controller for the second Available position controller	& assign it
	pc = 	position_constraint()
	obj.pos.controller.Available.controller = pc
	
	return pc
)


function add_look_at_constraint_controller obj  =
(
	-- create a Position List controller for the position controller
	obj.rotation.controller = rotation_list()

	-- create a Position Script controller for the second Available position controller	& assign it
	lc = 	LookAt_constraint()
	lc.lookat_vector_length = 0
	obj.rotation.controller.Available.controller = lc
	
	return lc
)



function addChildren obj hierarchy = 
(	-- add object to the array 
	append hierarchy obj
	-- loop iver children and recursively add the children 
	for child in obj.children do 
		addChildren child hierarchy
	return hierarchy 
)


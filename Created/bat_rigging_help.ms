-- attach locaters 
--for i in numb locaters
--    path constrate
--    set percentage and put position 
perc = 0 
for sel in $ do (
	sel.pos.controller.Path_Constraint.controller.PERCENT = perc
	perc += 5
	
)
	



-- Make bones at selected Locaters 
count = 1
for sel in $ do (
	startPos=[0,0,0]
	endPos=[0,0,1]
	b = boneSys.createBone startPos endPos [0,0,1]
	b.width = 2
	b.height = 2
	b.taper = 30
	b.sideFins = off
	b.frontFin = off
	b.backFin = off
	b.name = "wing_R_bindJnt_" + (count as string) 
	b.pos = sel.pos 
	
	b.position.controller = position_list()
	pc = 	position_constraint()
	b.position.controller.Available.controller = pc
	--lc = child.controller = orientation_constraint() 
	pc.appendTarget sel 100
	pc.relative = true
		
	
	
	count += 1 
	--b.rotation = sel.rotation
)
---------------------

for sel in $ do (

	sel.rotation.controller.LookAt_Constraint.controller.viewline_length_abs = off
	sel.rotation.controller.LookAt_Constraint.controller.lookat_vector_length = 0
	
)




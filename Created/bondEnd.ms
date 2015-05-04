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

		with redraw off 
		(
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


clear() 

CreateEnd_btn.press



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

bob = $
clearSelection ()
createEnd bob w
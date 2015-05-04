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

	

function make_image_planes_for_images imageArray = 
(
	usedHeader = #() 
	numberInc= 0
	
	for i in imageArray do 
	(
		--- Get the file name header
		header = get_image_headder i
		
		-- If it is the first time incountering this header
		if findItem usedHeader header == 0 then 
		(
			-- Create a New sub object  Material for it
			multMtrl = MultiMaterial numsubs:0
			
			-- Name it the same as the header
			MMName = header as string + "_MultiMaterial" 
			multMtrl.name = MMName
			--print "here is the mm name: "
			--print multMtrl.name
			-- Create a new standard material 
			standMtrl = StandardMaterial()
			showTextureMap standMtrl on
			
			-- Rename the standard material 
			SMName = header as string +"_"+  numberInc as string + "_StandardMaterial"
			standMtrl.name = SMName

			-- Create a bit map for this image 
			myBmp = bitmaptexture filename: i 
			
			-- plug the image into the diffuse of the material 
			standMtrl.diffusemap = myBmp
			
			-- plug the image alpha into the alpha channel of the material 
			-- makes sure that mono output is set to alpha
			myBmp.monoOutput = 1
			standMtrl.Opacitymap = myBmp
			myBmp.name = header as string +"_"+  numberInc as string + "_BitMap"
			
			-- plug the material into the Sub object id  index of 01
			multMtrl[1] =  standMtrl
			
			-- get file size 
			fileBitmap = openbitmap i 
			bitMapWidth = fileBitmap.width
			bitMapHeight = fileBitmap.height
			close fileBitmap 
			bitMapWidth = bitMapWidth*.25
			bitMapHeight = bitMapHeight*.25
			
			planeName =  header as string  +"_plane_Geo"
			myPlane = plane name:planeName length:bitMapHeight width:bitMapWidth lengthsegs:1 widthsegs:1 
			myPlane.material = multMtrl
			materialmodifer 
			matMod = Materialmodifier()  
			addModifier myPlane matMod
			numberInc += 1 
			append usedHeader header
		)	
		
		else 
		(
			-- Create a new standard material 
			standMtrl = StandardMaterial()
			showTextureMap standMtrl on
				
			-- Rename the standard material 
			SMName = header as string + numberInc as string + "_StandardMaterial"
			standMtrl.name = SMName
			
			-- Create a bit map for this image 
			myBmp = bitmaptexture filename: i 
			
			-- Plug the image into the diffuse of the material 
			standMtrl.diffusemap = myBmp
			
			-- Plug the image alpha into the alpha channel of the material 
			-- Makes sure that mono output is set to alpha
			myBmp.monoOutput = 1
			standMtrl.Opacitymap = myBmp
			myBmp.name = header as string +"_"+  numberInc as string + "_BitMap"
			
			
			-- Find matching Mulit ID 
			theMaterials = for m in SceneMaterials collect m
			print "ok here is theMaterials"
			print theMaterials

			
			myMultiMaterial= undefined
			for i in theMaterials do 
			(	
				if i.name == header+"_MultiMaterial" do
				(	
					myMultiMaterial = i  
					print "OK here is my matching MultiMateral" 
					print myMultiMaterial
					break
				)
				--print "OK here is my fucking  MultiMateril Name"
				--print myMultiMaterial.name
			)
				
			--matIndex = findItem theMaterials header+"_MultiMaterial"
			--myMultiMaterial = theMaterials[theMaterials]
						
			
			--theMaterials[2].numsubs
			MMIndex = myMultiMaterial.numsubs 
			MMIndex +=1
			
			myMultiMaterial.numsubs +=1
			myMultiMaterial[MMIndex] =  standMtrl					
		)
	)
)



rollout Create_planes_Rollout  "Find Directory" width:275 height:170
(
	button btnSetD "Set Dir:" pos:[5,11] width:42 height:22 toolTip:"locate your images"  
	edittext Fdir "" pos:[50,13] width:201 height:17
	button createImagePlanesBtn "Create Image Planes with Images" pos:[5,40] width:200 height:22 toolTip:"Makes an image plane for every imgage in you directory based on the Header of the file name" 
		
	on btnSetD pressed do
	(
		local curpath = Fdir.text 
		local newPath = getSavePath initialDir:(curpath) caption:"Select the path where your Face Images are located" 
		Fdir.text  = newPath
	)
	
	on createImagePlanesBtn pressed do 
	(
		if Fdir.text != undefined do
		(
		-- Direcory of where the images are
		--direcory = "C:\Users\dkstaff\Desktop\\LES_SCHWAB_for_Andrez\\02_Elements\\04_Raster\\01_PSDs\\01_Characters\\Man_Image5\\*.png"
		directory_pngWildCard = Fdir.text as string + "\\*.png"
		directory = directory_pngWildCard
		print "here is the directory wild card!"
		print directory
		-- Get an array of all png images in direcory
		imageArray = getFiles directory
		
		make_image_planes_for_images imageArray
		--print "These are the images: "
		--print imageArray
		)	
	)
)



--if FaceFloater != undefined then CloseRolloutFloater FaceFloater
--Box_Offset_Toolbox_MasterFloater = newRolloutFloater "Live Offset Toolbox v1.0" 255 575 380 (screenMiddle-450)
try (CloseRolloutFloater FaceFloater) catch()

-- destroydialog FaceFloater
-- CloseRolloutFloater FaceFloater

FaceFloater = newRolloutFloater "DK Bitmap to Material Loader " 275 176
cui.RegisterDialogBar FaceFloater style:#(#cui_floatable,#cui_dock_left,#cui_dock_right,#cui_handles)

addRollout Create_planes_Rollout FaceFloater



--point()

-- Place Pivit for each

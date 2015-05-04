-- DK Create Spheres from Materals 
--Created by Dr.Dre aka Andrez Aguayo
-- 11/07/14

-- Knowen Bugs
---> if you already have a materal lib loaded, and choose  pick a Scene Libary. If you hit close or exit with out opening up a proper file, 
--- it will create shaders even thought you did not select one. Because there is one arady loaded. 

--- check if object is a materal classc
--bob = classof i
--if bob == "material" 

/*
theMaterials = for m in SceneMaterials collect m

i = theClass
isMaterial = false
while theClass != undefined do
(
	theClass = classof theClass 
	if theClass == material then
	(		
		isMaterial = true
		break
	)
)
bob = classOf theMaterials[1]
bob2 = classOf bob
bob3 = classOf bob2
bob4 = classof bob3
tits = classof bob4
classof tits
getClassInstances theMaterials[1]
*/

function make_them_Balls materialSelectionType = 
(
	-- materialSelectionType 1 is SceneMaterials
	if materialSelectionType == 1  then 
	(
		theMaterials = for m in SceneMaterials collect m
	)
	
	-- materialSelectionType 1 is currentMaterialLibrary
	else if  materialSelectionType == 2 then
	(
		fileOpenMatLib()
		theMaterials = for m in currentMaterialLibrary collect m
	)
	else
	(
		theMaterials = #()
		for aMtlType in material.classes do 
		(
			for aMtl in (getClassInstances aMtlType processAllAnimatables:true) do
			(
				append theMaterials aMtl
				-- Does this material exist in the scene or not?
			   -- if (findItem sceneMaterials aMtl) == 0 do (print "This material does not exist in the scene")
			)
		)
	)
	
	space = 0 
	
	if theMaterials.count > 0 then 
		for i in theMaterials do
		(
			--print i.name
			sphereName = i.name +"_Sphere"
			mySphere = sphere name:sphereName radius:10 segments:25
		
			textName = i.name 
			theText = textName as string +"_Txt"
			matText = text text:textName size:5 wirecolor:green name:theText
			
			mySphere.material = i 
			space += 55
			mySphere.position = [space,0,0]
			matText.position = [space,0,-20]
			--quatToEuler
			rotate matText (angleaxis 90 [1,0,0])
			matText.parent = mySphere
		)	
	else print "There are no materals to use based off of your selection"
) 

--make_them_Balls 2

--$.rotation.x = 90
rollout sceneMaterialstoSpheresRollout "DK Scene Materials to Spheres" width:265 height:150
(	
	--GroupBox grp1 "GRID " pos:[4,10] width:230 height:160
	---checkbox rememberSelection "Remember Selection"  pos:[13,26] width:200 height:15 checked:true

	radiobuttons materalSelectionType "Materal Selection"  labels:#("Use Scene Materials", "Pick a Scene Library", "Use EVERY Material in file") pos:[13,10] --columns:1
	
	--checkbox useDistanceLocater "Use Distance " pos:[13,30] width:100 height:15 
	button make_them_balls_button "MAKE THEM BALLS" pos:[25,85] width:200 height:40 tooltip:"Create a line of balls with every material"
	
	
	on make_them_balls_button pressed do	
	(
		theMaterials=#()
		radiobuttonResult = materalSelectionType.state 
		-- print julia
		make_them_Balls radiobuttonResult
	)
)





--// Drawing User Interface Window
screenHeight = sysInfo.desktopSize[2] --the second value in the point2 is the height
screenMiddle = screenHeight / 2


-- Trying out some new things, this is a try and catch statment 
try (destroydialog sceneMaterialstoSpheresGUI) catch()

-- if arrayGUI != undefined do DestroyDialog arrayGUI
	
createDialog sceneMaterialstoSpheresRollout "Live Grid Array v1.0" width:255 hight:550 ---380 (screenMiddle-450)
sceneMaterialstoSpheresGUI = sceneMaterialstoSpheresRollout
